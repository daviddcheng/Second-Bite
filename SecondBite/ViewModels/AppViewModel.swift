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
    
    // User preferences - single source of truth for user data including balance
    @Published var userPreferences: UserPreferences {
        didSet {
            // Persist any changes to user preferences
            persistenceService.saveUserPreferences(userPreferences)
        }
    }
    
    // Computed property for dining balance - uses userPreferences as single source of truth
    var diningBalance: Double {
        get { userPreferences.balance }
        set {
            userPreferences.balance = newValue
        }
    }

    @Published var userLocation: CLLocation?
    @Published var locationAuthorizationStatus: CLAuthorizationStatus = .notDetermined

    private let locationService = LocationService()
    private let persistenceService = PersistenceService.shared

    init(diningHalls: [DiningHall] = SampleData.halls) {
        self.diningHalls = diningHalls
        self.userPreferences = PersistenceService.shared.loadUserPreferences()
        locationService.delegate = self
    }
    
    /// Reload preferences from storage (useful when returning from other views)
    func reloadPreferences() {
        userPreferences = persistenceService.loadUserPreferences()
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
    
    /// Reserve a surprise bag from a dining hall
    /// Deducts $10 from the user's balance if they have sufficient funds
    func reserve(from hall: DiningHall) -> Bool {
        // For now, a simple flat $10 reservation that cannot overdraft
        guard diningBalance >= 10 else { return false }
        diningBalance -= 10
        return true
    }
}
