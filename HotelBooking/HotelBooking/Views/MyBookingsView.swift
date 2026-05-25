import SwiftUI

struct MyBookingsView: View {
    @State private var bookings: [Booking] = []

    var body: some View {
        NavigationView {
            List(bookings) { booking in
                VStack(alignment: .leading) {
                    Text("Отель ID: \(booking.hotelId)")
                    Text("Заезд: \(booking.checkIn.formatted(date: .abbreviated, time: .omitted))")
                    Text("Выезд: \(booking.checkOut.formatted(date: .abbreviated, time: .omitted))")
                    Text("Гостей: \(booking.guests)")
                    Text("Итого: \(booking.totalPrice, specifier: "%.0f") руб")
                }
            }
            .navigationTitle("Мои брони")
            .onAppear {
                bookings = BookingService().getAllBookings()
            }
        }
    }
}

