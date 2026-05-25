import SwiftUI

struct HotelDetailView: View {
    let hotel: Hotel
    @Binding var selectedTab: Int
    @Binding var currentBooking: Booking?
    @State private var checkIn = Date()
    @State private var checkOut = Date().addingTimeInterval(86400)
    @State private var guests = 1
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Section("Отель") {
                Text(hotel.name).font(.title)
                Text("Цена за ночь: \(hotel.pricePerNight, specifier: "%.0f") руб")
            }
            Section("Даты") {
                DatePicker("Заезд", selection: $checkIn, in: Date()..., displayedComponents: .date)
                DatePicker("Выезд", selection: $checkOut, in: checkIn..., displayedComponents: .date)
            }
            Section("Гости") {
                Stepper("\(guests) гостей", value: $guests, in: 1...6)
            }
            Button("Забронировать") {
                let validator = BookingDateValidator()
                if validator.isValid(checkIn: checkIn, checkOut: checkOut) && validator.isGuestCountValid(guests) {
                    let booking = Booking(hotelId: hotel.id, checkIn: checkIn, checkOut: checkOut, guests: guests)
                    let service = BookingService()
                    if service.save(booking) {
                        currentBooking = booking
                        alertMessage = "Бронирование успешно!"
                        showAlert = true
                        selectedTab = 1
                    } else {
                        alertMessage = "Ошибка сохранения"
                        showAlert = true
                    }
                } else {
                    alertMessage = "Неверные даты или количество гостей"
                    showAlert = true
                }
            }
        }
        .navigationTitle(hotel.name)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Бронирование"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
