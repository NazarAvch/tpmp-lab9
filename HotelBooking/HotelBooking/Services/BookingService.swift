import Foundation

class BookingService {
    private let database: DatabaseProtocol
    
    init(database: DatabaseProtocol = SQLiteDatabase.shared) {
        self.database = database
    }
    
    func save(_ booking: Booking) -> Bool {
        return database.saveBooking(booking)
    }
    
    func getAllBookings() -> [Booking] {
        return database.fetchBookings()
    }
    
    func cancelBooking(_ id: UUID) -> Bool {
        return database.deleteBooking(id)
    }
}
