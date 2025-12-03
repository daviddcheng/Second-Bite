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

    // Halls filtered by the search bar (for pins)
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
                    MapCompass()
                    MapScaleView()
                }
                .onAppear {
                    appViewModel.requestLocationAccess()
                    appViewModel.startLocationUpdates()
                }
                .onDisappear {
                    appViewModel.stopLocationUpdates()
                }
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
                                .submitLabel(.search)             // shows "Search" button on keyboard
                                .onSubmit { performSearch() }     // 👈 when Return pressed
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

    /// Called when the user hits Return in the search field
    private func performSearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }

        let halls = appViewModel.diningHalls

        // 1. Try exact match first
        if let exact = halls.first(where: {
            $0.name.compare(query, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }) {
            goTo(hall: exact)
            return
        }

        // 2. Otherwise first partial match
        if let partial = halls.first(where: {
            $0.name.localizedCaseInsensitiveContains(query)
        }) {
            goTo(hall: partial)
        }
    }

    private func goTo(hall: DiningHall) {
        // Center map on hall
        cameraPosition = .region(
            MKCoordinateRegion(
                center: hall.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01,
                                       longitudeDelta: 0.01)
            )
        )

        // Open detail
        selectedHall = hall
    }
}

#Preview {
    MapView()
        .environmentObject(AppViewModel())
}
