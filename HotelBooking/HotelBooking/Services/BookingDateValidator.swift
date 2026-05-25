import Foundation

class BookingDateValidator {
    func isValid(checkIn: Date, checkOut: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.startOfDay(for: checkIn)
        let end = calendar.startOfDay(for: checkOut)
        return start > today && end > start
    }
    
    func isGuestCountValid(_ count: Int) -> Bool {
        return (1...6).contains(count)
    }
}
