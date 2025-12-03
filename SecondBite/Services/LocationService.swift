import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationService(_ service: LocationService, didUpdateAuthorization status: CLAuthorizationStatus)
    func locationService(_ service: LocationService, didUpdateLocation location: CLLocation)
}

final class LocationService: NSObject {
    private let manager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.locationService(self, didUpdateAuthorization: manager.authorizationStatus)

        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.locationService(self, didUpdateLocation: location)
    }
}
