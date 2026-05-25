import XCTest
@testable import HotelBooking

// MARK: - Mock-объекты
class MockDatabase: DatabaseProtocol {
    var savedBookings: [Booking] = []
    func saveBooking(_ booking: Booking) -> Bool {
        savedBookings.append(booking)
        return true
    }
    func fetchBookings() -> [Booking] { return savedBookings }
    func deleteBooking(_ id: UUID) -> Bool { return true }
}

class MockUserDefaults: UserDefaultsProtocol {
    var storedUser: User?
    func saveUser(_ user: User) { storedUser = user }
    func loadUser() -> User? { return storedUser }
    func clearUser() { storedUser = nil }
}

final class HotelBookingUnitTests: XCTestCase {

    // 1. Тест модели Hotel
    func testHotelModelInitialization() {
        let hotel = Hotel(id: 101, name: "Grand Plaza", pricePerNight: 250.0, rating: 4.5)
        XCTAssertEqual(hotel.id, 101)
        XCTAssertEqual(hotel.name, "Grand Plaza")
        XCTAssertEqual(hotel.pricePerNight, 250.0)
        XCTAssertEqual(hotel.rating, 4.5)
    }

    // 2. Тест валидации дат
    func testBookingDateValidation() {
        let validator = BookingDateValidator()
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        XCTAssertTrue(validator.isValid(checkIn: tomorrow, checkOut: nextWeek))
        XCTAssertFalse(validator.isValid(checkIn: nextWeek, checkOut: tomorrow))
    }

    // 3. Сохранение брони (мок БД)
    func testSaveBookingToDatabase() {
        let dbMock = MockDatabase()
        let bookingService = BookingService(database: dbMock)
        let booking = Booking(id: UUID(), hotelId: 101, checkIn: Date(), checkOut: Date().addingTimeInterval(86400), guests: 2)
        let success = bookingService.save(booking)
        XCTAssertTrue(success)
        XCTAssertEqual(dbMock.savedBookings.count, 1)
    }

    // 4. Фильтрация рейсов по типу транспорта
    func testFilterFlightsByTransportType() {
        let flights: [Flight] = [
            Flight(name: "Aeroflot", price: 150, type: .plane, departureTime: Date(), arrivalTime: Date()),
            Flight(name: "RZD", price: 70, type: .train, departureTime: Date(), arrivalTime: Date()),
            Flight(name: "FlixBus", price: 40, type: .bus, departureTime: Date(), arrivalTime: Date())
        ]
        let planeFlights = flights.filter { $0.type == .plane }
        XCTAssertEqual(planeFlights.count, 1)
        XCTAssertEqual(planeFlights.first?.name, "Aeroflot")
    }

    // 5. Регистрация через UserDefaults (мок)
    func testUserRegistrationWithUserDefaults() {
        let storage = MockUserDefaults()
        let user = User(email: "john@example.com", password: "123456", name: "John")
        storage.saveUser(user)
        let loaded = storage.loadUser()
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.email, "john@example.com")
        XCTAssertEqual(loaded?.name, "John")
    }

    // 6. Расчёт общей стоимости бронирования
    func testTotalPriceCalculation() {
        let hotel = Hotel(id: 1, name: "Test Hotel", pricePerNight: 100.0, rating: 4.0)
        let checkIn = Date()
        let checkOut = Calendar.current.date(byAdding: .day, value: 3, to: checkIn)!
        let nights = Calendar.current.dateComponents([.day], from: checkIn, to: checkOut).day ?? 0
        let total = Double(nights) * hotel.pricePerNight
        XCTAssertEqual(total, 300.0, accuracy: 0.01)
    }

    // 7. Уникальность ID бронирования
    func testBookingIDUnique() {
        let booking1 = Booking(hotelId: 1, checkIn: Date(), checkOut: Date(), guests: 1)
        let booking2 = Booking(hotelId: 1, checkIn: Date(), checkOut: Date(), guests: 1)
        XCTAssertNotEqual(booking1.id, booking2.id)
    }

    // 8. Валидация количества гостей
    func testGuestCountValidation() {
        let validator = BookingDateValidator()
        XCTAssertTrue(validator.isGuestCountValid(1))
        XCTAssertTrue(validator.isGuestCountValid(4))
        XCTAssertFalse(validator.isGuestCountValid(0))
        XCTAssertFalse(validator.isGuestCountValid(7))
    }

    // 9. Сортировка рейсов по цене
    func testFlightsSortingByPrice() {
        let flights = [
            Flight(name: "Expensive", price: 300, type: .plane, departureTime: Date(), arrivalTime: Date()),
            Flight(name: "Cheap", price: 50, type: .bus, departureTime: Date(), arrivalTime: Date()),
            Flight(name: "Medium", price: 150, type: .train, departureTime: Date(), arrivalTime: Date())
        ]
        let sorted = flights.sorted { $0.price < $1.price }
        XCTAssertEqual(sorted.first?.name, "Cheap")
        XCTAssertEqual(sorted.last?.name, "Expensive")
    }

    // 10. Наличие ключей локализации
    func testLocalizationKeysExist() {
        let key = "booking_button_title"
        let localized = NSLocalizedString(key, comment: "")
        XCTAssertNotEqual(localized, key)
        XCTAssertFalse(localized.isEmpty)
    }

    // 11. Чтение/запись UserDefaults (реальный)
    func testUserDefaultsStorage() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "notifications_enabled")
        let isEnabled = defaults.bool(forKey: "notifications_enabled")
        XCTAssertTrue(isEnabled)
        defaults.removeObject(forKey: "notifications_enabled")
    }
}



