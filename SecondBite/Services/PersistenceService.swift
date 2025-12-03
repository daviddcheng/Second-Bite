import Foundation

final class PersistenceService {
    
    static let shared = PersistenceService()
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let userPreferences = "userPreferences"
    }
    
    private init() {}
    
    func saveUserPreferences(_ preferences: UserPreferences) {
        do {
            let encoded = try JSONEncoder().encode(preferences)
            userDefaults.set(encoded, forKey: Keys.userPreferences)
        } catch {
            print("Error encoding user preferences: \(error)")
        }
    }
    
    func loadUserPreferences() -> UserPreferences {
        guard let data = userDefaults.data(forKey: Keys.userPreferences) else {
            return UserPreferences()
        }
        
        do {
            let decoded = try JSONDecoder().decode(UserPreferences.self, from: data)
            return decoded
        } catch {
            print("Error decoding user preferences: \(error)")
            return UserPreferences()
        }
    }
    
    func updateBalance(_ newBalance: Double) {
        var preferences = loadUserPreferences()
        preferences.balance = newBalance
        saveUserPreferences(preferences)
    }
    
    func deductFromBalance(amount: Double) -> Bool {
        var preferences = loadUserPreferences()
        guard preferences.balance >= amount else {
            return false
        }
        preferences.balance -= amount
        saveUserPreferences(preferences)
        return true
    }
    
    func clearAllData() {
        userDefaults.removeObject(forKey: Keys.userPreferences)
    }
}
