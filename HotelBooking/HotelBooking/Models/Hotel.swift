import Foundation

struct Hotel: Identifiable, Codable {
    let id: Int
    let name: String
    let pricePerNight: Double
    let rating: Double
    let imageName: String
    
    static let sampleHotels = [
        Hotel(id: 1, name: "Sunset Resort", pricePerNight: 120, rating: 4.5, imageName: "hotel1"),
        Hotel(id: 2, name: "Mountain View", pricePerNight: 90, rating: 4.2, imageName: "hotel2"),
        Hotel(id: 3, name: "City Center Inn", pricePerNight: 150, rating: 4.7, imageName: "hotel3")
    ]
}
