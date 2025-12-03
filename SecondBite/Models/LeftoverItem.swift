//
//  LeftoverItem.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import Foundation

struct LeftoverItem: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let quantity: Int
    let price: Double
    let isVegetarian: Bool
    let isVegan: Bool
    let isGlutenFree: Bool
    let isHalal: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        quantity: Int,
        price: Double = 5.00,
        isVegetarian: Bool = false,
        isVegan: Bool = false,
        isHalal: Bool = false,
        isGlutenFree: Bool = false
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.price = price
        self.isVegetarian = isVegetarian
        self.isVegan = isVegan
        self.isGlutenFree = isGlutenFree
        self.isHalal = isHalal
    }
    
    var formattedPrice: String {
        String(format: "$%.2f", price)
    }
    
    var dietaryTags: [String] {
        var tags: [String] = []
        if isVegetarian { tags.append("Vegetarian") }
        if isVegan { tags.append("Vegan") }
        if isGlutenFree { tags.append("Gluten-Free") }
        if isHalal { tags.append("Halal") }
        return tags
    }
}
