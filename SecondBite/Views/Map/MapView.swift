//
//  MapView.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//
//
//  MapView.swift
//  SecondBite
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.9522, longitude: -75.1932),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )

    @State private var searchText: String = ""
    @State private var selectedHall: DiningHall?

    // Halls filtered by the search bar
    private var filteredHalls: [DiningHall] {
        let halls = appViewModel.diningHalls
        guard !searchText.isEmpty else { return halls }

        return halls.filter { hall in
            hall.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: Map
                Map(position: $cameraPosition) {
                    // 🔵 user location dot
                    UserAnnotation()

                    // Dining hall pins
                    ForEach(filteredHalls) { hall in
                        Annotation(hall.name, coordinate: hall.coordinate) {
                            // 👇 Make pin tappable to open detail
                            Button {
                                selectedHall = hall
                            } label: {
                                VStack(spacing: 4) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title)

                                    Text(hall.name)
                                        .font(.caption2)
                                        .padding(4)
                                        .background(.thinMaterial)
                                        .cornerRadius(6)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .mapStyle(.standard)
                .mapControls {
                    MapCompass()   // Apple’s built-in compass (top-right)
                    MapScaleView()
                }
                // Ask for location + start updates when map appears
                .onAppear {
                    appViewModel.requestLocationAccess()
                    appViewModel.startLocationUpdates()
                }
                .onDisappear {
                    appViewModel.stopLocationUpdates()
                }
                // Center map when we get a user location (iOS 17+ onChange)
                .onChange(of: appViewModel.userLocation, initial: false) { _, newLocation in
                    guard let loc = newLocation else { return }

                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: loc.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                   longitudeDelta: 0.01)
                        )
                    )
                }

                // MARK: Overlays: search bar + center button
                VStack {
                    // Search bar at top
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)

                            TextField("Search dining halls", text: $searchText)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        .padding(10)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                        .frame(maxWidth: 310)
                        Spacer()
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 16)

                    Spacer()

                    // Center-on-user button at bottom-right
                    HStack {
                        Spacer()
                        Button(action: centerOnUserLocation) {
                            Image(systemName: "location.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(14)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.bottom, 24)
                        .padding(.trailing, 20)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            // 👇 When selectedHall is set, push detail view
            .navigationDestination(item: $selectedHall) { hall in
                DiningHallDetailView(hall: hall)
                    .environmentObject(appViewModel)
            }
        }
    }

    // MARK: - Helpers

    private func centerOnUserLocation() {
        guard let loc = appViewModel.userLocation else { return }

        cameraPosition = .region(
            MKCoordinateRegion(
                center: loc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01,
                                       longitudeDelta: 0.01)
            )
        )
    }
}

#Preview {
    MapView()
        .environmentObject(AppViewModel())
}
