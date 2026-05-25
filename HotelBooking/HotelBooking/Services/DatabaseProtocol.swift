import Foundation

protocol DatabaseProtocol {
    func saveBooking(_ booking: Booking) -> Bool
    func fetchBookings() -> [Booking]
    func deleteBooking(_ id: UUID) -> Bool
}
