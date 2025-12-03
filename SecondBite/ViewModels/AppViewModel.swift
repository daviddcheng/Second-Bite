import Foundation
import Combine
import CoreLocation

final class AppViewModel: ObservableObject, LocationServiceDelegate {
    // Core app state
    @Published var diningHalls: [DiningHall]
    
    // Current reservation
    @Published var currentReservation: Reservation?
    
    // User preferences
    @Published var userPreferences: UserPreferences {
        didSet {
            // Persist any changes to user preferences
            persistenceService.saveUserPreferences(userPreferences)
        }
    }
    
    // Computed property for dining balance
    var diningBalance: Double {
        get { userPreferences.balance }
        set {
            userPreferences.balance = newValue
        }
    }

    @Published var userLocation: CLLocation?
    @Published var locationAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    
    // Reservation model
    struct Reservation: Identifiable {
        let id = UUID()
        let diningHall: DiningHall
        let pickupTime: String
        let timestamp: Date
    }

    private let locationService = LocationService()
    private let persistenceService = PersistenceService.shared

    init(diningHalls: [DiningHall] = SampleData.halls) {
        self.diningHalls = diningHalls
        self.userPreferences = PersistenceService.shared.loadUserPreferences()
        locationService.delegate = self
    }
    
    /// Reload preferences from storage
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
    
    // Reserve a surprise bag from a dining hall
    func reserve(from hall: DiningHall) -> Bool {
        guard diningBalance >= 10 else { return false }
        diningBalance -= 10
        
        // Set the current reservation
        currentReservation = Reservation(
            diningHall: hall,
            pickupTime: "7:45 PM – 8:30 PM",
            timestamp: Date()
        )
        
        return true
    }
    
    // Cancel current reservation
    func cancelReservation() {
        currentReservation = nil
    }
}
