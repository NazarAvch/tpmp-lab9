import Foundation

 

enum TransportType: String, CaseIterable, Codable {

    case plane = "Самолёт"

    case train = "Поезд"

    case bus = "Автобус"

}

 

struct Flight: Identifiable, Codable {

    let id: UUID

    let name: String

    let price: Double

    let type: TransportType

    let departureTime: Date

    let arrivalTime: Date

 

     // Добавили собственный инициализатор (значение id по умолчанию – новый UUID)

    init(id: UUID = UUID(), name: String, price: Double, type: TransportType, departureTime: Date, arrivalTime: Date) {

        self.id = id

        self.name = name

        self.price = price

        self.type = type

        self.departureTime = departureTime

        self.arrivalTime = arrivalTime

    }

    

     // Примеры рейсов (теперь работают)

    static let sampleFlights = [

        Flight(name: "Aeroflot", price: 200, type: .plane,

                departureTime: Date(), arrivalTime: Date().addingTimeInterval(7200)),

        Flight(name: "RZD", price: 80, type: .train,

                departureTime: Date(), arrivalTime: Date().addingTimeInterval(10800)),

        Flight(name: "FlixBus", price: 45, type: .bus,

                departureTime: Date(), arrivalTime: Date().addingTimeInterval(14400)),

        Flight(name: "S7 Airlines", price: 250, type: .plane,

                departureTime: Date(), arrivalTime: Date().addingTimeInterval(5400))

    ]

}
