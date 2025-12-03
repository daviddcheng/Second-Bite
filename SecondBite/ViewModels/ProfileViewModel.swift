import Foundation
import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published var preferences: UserPreferences
    @Published var showingPreferencesForm: Bool = false
    @Published var purchaseAlert: PurchaseAlert?
    
    private let persistenceService = PersistenceService.shared
    
    struct PurchaseAlert: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }
    
    init() {
        self.preferences = persistenceService.loadUserPreferences()
    }
    
    // Reload preferences from storage
    func reloadPreferences() {
        preferences = persistenceService.loadUserPreferences()
    }
    
    // Save current preferences to storage
    func savePreferences() {
        persistenceService.saveUserPreferences(preferences)
    }
    
    // Update a single preference and save
    func updatePreferences(_ newPreferences: UserPreferences) {
        preferences = newPreferences
        savePreferences()
    }
    
    func purchaseItem(price: Double, itemName: String) -> Bool {
        guard preferences.canAfford(price: price) else {
            purchaseAlert = PurchaseAlert(
                title: "Insufficient Balance",
                message: "You don't have enough dining dollars for \(itemName). Your balance is \(preferences.formattedBalance)."
            )
            return false
        }
        
        preferences.balance -= price
        savePreferences()
        
        purchaseAlert = PurchaseAlert(
            title: "Purchase Successful!",
            message: "You purchased \(itemName) for \(String(format: "$%.2f", price)). New balance: \(preferences.formattedBalance)"
        )
        return true
    }
    
    // Add dining dollars to balance
    func addFunds(amount: Double) {
        preferences.balance += amount
        savePreferences()
    }
    
    // Toggle a dining hall as favorite
    func toggleFavoriteDiningHall(_ hallName: String) {
        if preferences.favoriteDiningHalls.contains(hallName) {
            preferences.favoriteDiningHalls.removeAll { $0 == hallName }
        } else {
            preferences.favoriteDiningHalls.append(hallName)
        }
        savePreferences()
    }
    
    // Check if a dining hall is favorited
    func isFavorite(_ hallName: String) -> Bool {
        preferences.favoriteDiningHalls.contains(hallName)
    }
    
    // Reset to default preferences
    func resetToDefaults() {
        preferences = UserPreferences()
        savePreferences()
    }
}
