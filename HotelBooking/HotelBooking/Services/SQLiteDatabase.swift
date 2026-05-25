import Foundation
import SQLite

class SQLiteDatabase: DatabaseProtocol {
    static let shared = SQLiteDatabase()
    private var db: Connection?
    private let bookingsTable = Table("bookings")
    private let id = Expression<UUID>("id")
    private let hotelId = Expression<Int>("hotelId")
    private let checkIn = Expression<Date>("checkIn")
    private let checkOut = Expression<Date>("checkOut")
    private let guests = Expression<Int>("guests")
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbPath = path + "/hotel.sqlite3"
        do {
            db = try Connection(dbPath)
            try db?.run(bookingsTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(hotelId)
                t.column(checkIn)
                t.column(checkOut)
                t.column(guests)
            })
        } catch {
            print("DB init error: \(error)")
        }
    }
    
    func saveBooking(_ booking: Booking) -> Bool {
        guard let db = db else { return false }
        let insert = bookingsTable.insert(
            id <- booking.id,
            hotelId <- booking.hotelId,
            checkIn <- booking.checkIn,
            checkOut <- booking.checkOut,
            guests <- booking.guests
        )
        do {
            try db.run(insert)
            return true
        } catch {
            print("Save error: \(error)")
            return false
        }
    }
    
    func fetchBookings() -> [Booking] {
        guard let db = db else { return [] }
        var bookings: [Booking] = []
        do {
            for booking in try db.prepare(bookingsTable) {
                let b = Booking(
                    id: booking[id],
                    hotelId: booking[hotelId],
                    checkIn: booking[checkIn],
                    checkOut: booking[checkOut],
                    guests: booking[guests]
                )
                bookings.append(b)
            }
        } catch {
            print("Fetch error: \(error)")
        }
        return bookings
    }
    
    func deleteBooking(_ id: UUID) -> Bool {
        guard let db = db else { return false }
        let target = bookingsTable.filter(self.id == id)
        do {
            try db.run(target.delete())
            return true
        } catch {
            return false
        }
    }
}
