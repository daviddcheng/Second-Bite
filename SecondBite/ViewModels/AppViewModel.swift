//
//  AppViewModel.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import Foundation
import Combine
import CoreLocation

final class AppViewModel: ObservableObject {
    // Core app state
    @Published var diningHalls: [DiningHall]
    @Published var diningBalance: Double
    
    // Location-related state (will be used later)
    @Published var userLocation: CLLocation?
    @Published var locationAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    
    init(diningHalls: [DiningHall] = SampleData.halls) {
        self.diningHalls = diningHalls
        self.diningBalance = 300
    }

    func reserve(from hall: DiningHall) {
        // For now, a simple flat $10 reservation that cannot overdraft
        guard diningBalance >= 10 else { return }
        diningBalance -= 10
    }
}
