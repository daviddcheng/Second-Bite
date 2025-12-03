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
                    }
                }
                .mapStyle(.standard)
                .mapControls {
                    MapCompass()   // ← Apple’s built-in compass (top-right)
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

                            TextField("Search", text: $searchText)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        .padding(10)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                        .frame(maxWidth: 310)   // shorter bar
                        // no extra leading padding here
                        Spacer()                 // pushes everything else to the right
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 16)    // left edge at 16, right side free

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
