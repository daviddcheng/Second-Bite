import Foundation
import CoreLocation

struct DiningHall: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let leftovers: [LeftoverItem]
    let imageName: String
    
    // Distance will later be filled in by the location logic
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        latitude: Double,
        longitude: Double,
        leftovers: [LeftoverItem],
        imageName: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.leftovers = leftovers
        self.imageName = imageName
    }
}
