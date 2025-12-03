//
//  AppViewModel.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import Foundation
import Combine
import CoreLocation

final class AppViewModel: ObservableObject, LocationServiceDelegate {
    // Core app state
    @Published var diningHalls: [DiningHall]

    @Published var diningBalance: Double

    @Published var userLocation: CLLocation?
    @Published var locationAuthorizationStatus: CLAuthorizationStatus = .notDetermined

    private let locationService = LocationService()

    init(diningHalls: [DiningHall] = SampleData.halls) {
        self.diningHalls = diningHalls
        locationService.delegate = self
    }

    func requestLocationAccess() {
        locationService.requestWhenInUseAuthorization()
    }

    func startLocationUpdates() {
        locationService.startUpdatingLocation()
    }

    func stopLocationUpdates() {
        locationService.stopUpdatingLocation()
    }

    // MARK: - LocationServiceDelegate

    func locationService(_ service: LocationService,
                         didUpdateAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationAuthorizationStatus = status
        }
    }

    func locationService(_ service: LocationService,
                         didUpdateLocation location: CLLocation) {
        DispatchQueue.main.async {
            self.userLocation = location
        }
    }
}
