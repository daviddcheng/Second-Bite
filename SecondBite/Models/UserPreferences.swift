//
//  UserPreferences.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import Foundation
import Combine

struct UserPreferences: Codable, Equatable {
    // Profile Info
    var name: String
    var email: String
    
    // Currency (Dining Dollars)
    var balance: Double
    
    // Dietary Preferences
    var isVegetarian: Bool
    var isVegan: Bool
    var requiresGlutenFree: Bool
    var requiresHalal: Bool
    
    // Budget Preferences
    var maxPricePerItem: Double
    
    // Favorite Dining Halls (stored by name)
    var favoriteDiningHalls: [String]
    
    // Default initializer with hardcoded values
    init(
        name: String = "Penn Student",
        email: String = "student@upenn.edu",
        balance: Double = 100.00,
        isVegetarian: Bool = false,
        isVegan: Bool = false,
        requiresGlutenFree: Bool = false,
        requiresHalal: Bool = false,
        maxPricePerItem: Double = 10.00,
        favoriteDiningHalls: [String] = []
    ) {
        self.name = name
        self.email = email
        self.balance = balance
        self.isVegetarian = isVegetarian
        self.isVegan = isVegan
        self.requiresGlutenFree = requiresGlutenFree
        self.requiresHalal = requiresHalal
        self.maxPricePerItem = maxPricePerItem
        self.favoriteDiningHalls = favoriteDiningHalls
    }
    
    var formattedBalance: String {
        String(format: "$%.2f", balance)
    }
    
    func canAfford(price: Double) -> Bool {
        return balance >= price
    }
    
    var activeDietaryRestrictions: [String] {
        var restrictions: [String] = []
        if isVegetarian { restrictions.append("Vegetarian") }
        if isVegan { restrictions.append("Vegan") }
        if requiresGlutenFree { restrictions.append("Gluten-Free") }
        if requiresHalal { restrictions.append("Halal") }
        return restrictions
    }
    
    func matchesDietaryPreferences(_ item: LeftoverItem) -> Bool {
        if isVegetarian && !item.isVegetarian { return false }
        if isVegan && !item.isVegan { return false }
        if requiresGlutenFree && !item.isGlutenFree { return false }
        if requiresHalal && !item.isHalal { return false }
        return true
    }
    
    func isWithinBudget(_ item: LeftoverItem) -> Bool {
        return item.price <= maxPricePerItem
    }
}
