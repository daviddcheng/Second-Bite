//
//  MapView.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
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
                .ignoresSafeArea()
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }

                VStack {
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
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    Spacer()

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

    private func centerOnUserLocation() {
        guard let loc = appViewModel.userLocation else { return }

        cameraPosition = .region(
            MKCoordinateRegion(
                center: loc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
}

#Preview {
    MapView()
        .environmentObject(AppViewModel())
}
