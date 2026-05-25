import SwiftUI
import MapKit

struct TransportSelectionView: View {
    let booking: Booking
    @State private var selectedType: TransportType = .plane
    @State private var showRouteMap = false
    @State private var flights = Flight.sampleFlights
    @State private var selectedFlight: Flight?

    var body: some View {
        NavigationView {
            VStack {
                // Кнопки выбора транспорта (для UI-тестов)
                HStack {
                    Button("Самолёт") {
                        selectedType = .plane
                    }
                    .accessibilityIdentifier("plane_button")
                    .padding()
                    .background(selectedType == .plane ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Поезд") {
                        selectedType = .train
                    }
                    .accessibilityIdentifier("train_button")
                    .padding()
                    .background(selectedType == .train ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Автобус") {
                        selectedType = .bus
                    }
                    .accessibilityIdentifier("bus_button")
                    .padding()
                    .background(selectedType == .bus ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()

                Button("Выбрать маршрут на карте") {
                    showRouteMap.toggle()
                }
                .accessibilityIdentifier("map_route_button")
                .padding()
                .sheet(isPresented: $showRouteMap) {
                    RouteMapView(flights: $flights, selectedType: selectedType)
                }

                List(flights.filter { $0.type == selectedType }) { flight in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(flight.name).font(.headline)
                            Text("\(flight.price, specifier: "%.0f") руб")
                        }
                        Spacer()
                        if selectedFlight?.id == flight.id {
                            Image(systemName: "checkmark")
                        }
                    }
                    .onTapGesture {
                        selectedFlight = flight
                    }
                }
                .accessibilityIdentifier("flights_list")
            }
            .navigationTitle("Выберите рейс")
        }
    }
}

struct RouteMapView: View {
    @Binding var flights: [Flight]
    let selectedType: TransportType
    @Environment(\.dismiss) var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
                .frame(height: 300)
                .accessibilityIdentifier("route_map")
            Text("Выберите точки на карте (демо-режим)").font(.caption)
            Button("Подтвердить маршрут") {
                flights = Flight.sampleFlights.filter { $0.type == selectedType }
                dismiss()
            }
            .accessibilityIdentifier("confirm_route_button")
            .padding()
        }
    }
}