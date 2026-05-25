import SwiftUI

struct HotelListView: View {
    @Binding var selectedTab: Int
    @Binding var currentBooking: Booking?
    @State private var hotels = Hotel.sampleHotels

    var body: some View {
        NavigationView {
            List(hotels) { hotel in
                NavigationLink(destination: HotelDetailView(hotel: hotel, selectedTab: $selectedTab, currentBooking: $currentBooking)) {
                    HStack {
                        Image(systemName: "building")
                            .resizable()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text(hotel.name).font(.headline)
                            Text("\(hotel.pricePerNight, specifier: "%.0f") руб/ночь")
                        }
                    }
                }
            }
            .accessibilityIdentifier("hotels_list")   // добавленная строка
            .navigationTitle("Отели")
        }
    }
}

