//
//  SampleData.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

// hardcoded leftover data

import Foundation

enum SampleData {
    static let halls: [DiningHall] = [
        DiningHall(
            name: "North Dining Hall",
            description: "Large dining hall with lots of options.",
            latitude: 39.9522,
            longitude: -75.1932,
            leftovers: [
                LeftoverItem(
                    name: "Margherita Pizza",
                    quantity: 8,
                    isVegetarian: true
                ),
                LeftoverItem(
                    name: "Grilled Chicken",
                    quantity: 5
                )
            ]
        ),
        DiningHall(
            name: "South Dining Hall",
            description: "Smaller hall, good vegetarian selection.",
            latitude: 39.9505,
            longitude: -75.1900,
            leftovers: [
                LeftoverItem(
                    name: "Veggie Pasta",
                    quantity: 10,
                    isVegetarian: true
                ),
                LeftoverItem(
                    name: "Gluten-Free Brownies",
                    quantity: 6,
                    isVegetarian: true,
                    isGlutenFree: true
                )
            ]
        )
    ]
}
