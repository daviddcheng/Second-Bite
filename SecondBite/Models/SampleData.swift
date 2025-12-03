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
            name: "1920 Commons",
            description: "Large central dining hall with a wide variety of classic and rotating options right by the Quad.",
            latitude: 39.952284,
            longitude: -75.195497,
            leftovers: [
                LeftoverItem(
                    name: "Late Night Pizza Slices",
                    quantity: 12,
                    isVegetarian: true
                ),
                LeftoverItem(
                    name: "Grilled Chicken Bowls",
                    quantity: 6
                )
            ],
            imageName: "1920Commons"
        ),
        DiningHall(
            name: "Hill House",
            description: "Cozy residential dining hall popular for breakfast and comfort food.",
            latitude: 39.955019,
            longitude: -75.193946,
            leftovers: [
                LeftoverItem(
                    name: "Veggie Pasta Bar",
                    quantity: 10,
                    isVegetarian: true
                ),
                LeftoverItem(
                    name: "Gluten-Free Brownies",
                    quantity: 8,
                    isVegetarian: true,
                    isGlutenFree: true
                )
            ],
            imageName: "HillHouse"
        ),
        DiningHall(
            name: "English House",
            description: "Fresh, modern dining hall on the east side of campus with lots of salad and grill options.",
            latitude: 39.952980,
            longitude: -75.199210,
            leftovers: [
                LeftoverItem(
                    name: "Grain Bowls",
                    quantity: 9,
                    isVegetarian: true
                ),
                LeftoverItem(
                    name: "Roasted Chicken",
                    quantity: 7
                )
            ],
            imageName: "EnglishHouse"
        ),
        DiningHall(
            name: "Lauder College House",
            description: "Scenic dining hall along the river with plenty of natural light and global cuisine stations.",
            latitude: 39.952627,
            longitude: -75.201540,
            leftovers: [
                LeftoverItem(
                    name: "Stir-Fry Bar",
                    quantity: 11,
                    isVegetarian: true
                ),
                LeftoverItem(
                    name: "Tandoori Chicken",
                    quantity: 5
                )
            ],
            imageName: "LauderCollegeHouse"
        ),
        DiningHall(
            name: "Falk Kosher Dining",
            description: "Certified kosher dining hall with rotating hot entrées and salads.",
            latitude: 39.954470,
            longitude: -75.200510,
            leftovers: [
                LeftoverItem(
                    name: "Falafel & Hummus Plates",
                    quantity: 10,
                    isVegetarian: true,
                    isVegan: true
                ),
                LeftoverItem(
                    name: "Kosher Chicken Cutlets",
                    quantity: 6
                )
            ],
            imageName: "FalkKosherDining"
        )
    ]
}
