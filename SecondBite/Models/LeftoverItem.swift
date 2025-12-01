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
    let isVegetarian: Bool
    let isVegan: Bool
    let isGlutenFree: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        quantity: Int,
        isVegetarian: Bool = false,
        isVegan: Bool = false,
        isGlutenFree: Bool = false
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.isVegetarian = isVegetarian
        self.isVegan = isVegan
        self.isGlutenFree = isGlutenFree
    }
}
