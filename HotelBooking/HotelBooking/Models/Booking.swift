import Foundation

struct Booking: Identifiable, Codable {
    let id: UUID
    let hotelId: Int
    let checkIn: Date
    let checkOut: Date
    let guests: Int
    var totalPrice: Double {
        let nights = Calendar.current.dateComponents([.day], from: checkIn, to: checkOut).day ?? 0
        let hotel = Hotel.sampleHotels.first(where: { $0.id == hotelId })!
        return Double(nights) * hotel.pricePerNight
    }
    
    init(id: UUID = UUID(), hotelId: Int, checkIn: Date, checkOut: Date, guests: Int) {
        self.id = id
        self.hotelId = hotelId
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.guests = guests
    }
}
