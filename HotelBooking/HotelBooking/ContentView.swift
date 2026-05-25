import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isLoggedIn = false
    @State private var currentBooking: Booking?
    
    var body: some View {
        if !isLoggedIn {
            LoginView(isLoggedIn: $isLoggedIn)
        } else {
            TabView(selection: $selectedTab) {
                HotelListView(selectedTab: $selectedTab, currentBooking: $currentBooking)
                    .tabItem { Label("Отели", systemImage: "building.2") }
                    .tag(0)
                
                if let booking = currentBooking {
                    TransportSelectionView(booking: booking)
                        .tabItem { Label("Транспорт", systemImage: "airplane") }
                        .tag(1)
                }
                
                MyBookingsView()
                    .tabItem { Label("Мои брони", systemImage: "book") }
                    .tag(2)
            }
        }
    }
}
