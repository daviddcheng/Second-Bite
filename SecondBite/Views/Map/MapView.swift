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

    // Start with automatic camera unless you prefer a region
    @State private var cameraPosition: MapCameraPosition = .automatic

    @State private var searchText: String = ""
    @State private var selectedHall: DiningHall?        // ← for navigation

    // Filtered hall list (used for pin display)
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
                // MARK: - Apple Map
                Map(position: $cameraPosition) {

                    UserAnnotation()   // 🔵 user location dot

                    // Dining hall pins
                    ForEach(filteredHalls) { hall in
                        Annotation("", coordinate: hall.coordinate) {
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
                    MapCompass()     // ← Apple compass (top-right)
                    MapScaleView()
                }
                .onAppear {
                    appViewModel.requestLocationAccess()
                    appViewModel.startLocationUpdates()
                }
                .onDisappear {
                    appViewModel.stopLocationUpdates()
                }
                .onChange(of: appViewModel.userLocation, initial: false) { _, loc in
                    guard let loc else { return }

                    // Center map on user when first loaded
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: loc.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                   longitudeDelta: 0.01)
                        )
                    )
                }

                // MARK: - Overlays (search + center button)
                VStack {
                    // SEARCH BAR
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)

                            TextField("Search dining halls", text: $searchText)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .submitLabel(.search)
                                .onSubmit { performSearch() }

                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                    hideKeyboard()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(10)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                        .frame(maxWidth: 300)      // controls width
                        Spacer()
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 16)

                    Spacer()

                    // CENTER-ON-USER BUTTON
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

            // NAVIGATION to DiningHallDetailView
            .navigationDestination(item: $selectedHall) { hall in
                DiningHallDetailView(hall: hall)
                    .environmentObject(appViewModel)
            }
        }
    }

    // MARK: - ACTIONS

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

    /// When user hits Return in search bar
    private func performSearch() {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }

        let halls = appViewModel.diningHalls

        // 1. Exact match
        if let exact = halls.first(where: {
            $0.name.compare(q, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }) {
            goTo(hall: exact)
            return
        }

        // 2. Partial match
        if let partial = halls.first(where: {
            $0.name.localizedCaseInsensitiveContains(q)
        }) {
            goTo(hall: partial)
        }
    }

    private func goTo(hall: DiningHall) {
        // Zoom to hall
        cameraPosition = .region(
            MKCoordinateRegion(
                center: hall.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01,
                                       longitudeDelta: 0.01)
            )
        )

        // Navigate to detail view
        selectedHall = hall

        hideKeyboard()
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

#Preview {
    MapView()
        .environmentObject(AppViewModel())
}
