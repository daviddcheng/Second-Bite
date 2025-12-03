//
//  SampleData.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import Foundation

enum SampleData {
    static let halls: [DiningHall] = [
        DiningHall(
            name: "Hill House Dining",
            description: "Large dining hall with diverse cuisine options.",
            latitude: 39.9531,
            longitude: -75.1910,
            leftovers: [
                LeftoverItem(
                    name: "Margherita Pizza",
                    quantity: 8,
                    price: 4.50,
                    isVegetarian: true
                ),
                LeftoverItem(
                    name: "Grilled Chicken Breast",
                    quantity: 5,
                    price: 6.00,
                    isHalal: true
                ),
                LeftoverItem(
                    name: "Caesar Salad",
                    quantity: 12,
                    price: 3.50,
                    isVegetarian: true,
                    isGlutenFree: true
                ),
                LeftoverItem(
                    name: "Beef Tacos",
                    quantity: 6,
                    price: 5.00
                )
            ]
        ),
        DiningHall(
            name: "Kings Court English House",
            description: "Cozy hall with excellent vegetarian selection.",
            latitude: 39.9515,
            longitude: -75.1935,
            leftovers: [
                LeftoverItem(
                    name: "Veggie Pasta Primavera",
                    quantity: 10,
                    price: 5.50,
                    isVegetarian: true,
                    isVegan: true
                ),
                LeftoverItem(
                    name: "Gluten-Free Brownies",
                    quantity: 6,
                    price: 2.50,
                    isVegetarian: true,
                    isGlutenFree: true
                ),
                LeftoverItem(
                    name: "Falafel Wrap",
                    quantity: 8,
                    price: 4.00,
                    isVegetarian: true,
                    isVegan: true,
                    isHalal: true
                )
            ]
        ),
        DiningHall(
            name: "1920 Commons",
            description: "Main campus dining with wide variety.",
            latitude: 39.9522,
            longitude: -75.1998,
            leftovers: [
                LeftoverItem(
                    name: "Salmon Fillet",
                    quantity: 4,
                    price: 8.00,
                    isGlutenFree: true
                ),
                LeftoverItem(
                    name: "Mushroom Risotto",
                    quantity: 7,
                    price: 6.50,
                    isVegetarian: true,
                    isGlutenFree: true
                ),
                LeftoverItem(
                    name: "Chicken Tikka Masala",
                    quantity: 9,
                    price: 7.00,
                    isHalal: true,
                    isGlutenFree: true
                ),
                LeftoverItem(
                    name: "Vegan Buddha Bowl",
                    quantity: 5,
                    price: 5.00,
                    isVegetarian: true,
                    isVegan: true,
                    isGlutenFree: true
                )
            ]
        ),
        DiningHall(
            name: "Lauder College House",
            description: "Modern dining with international flavors.",
            latitude: 39.9495,
            longitude: -75.1875,
            leftovers: [
                LeftoverItem(
                    name: "Sushi Platter",
                    quantity: 3,
                    price: 9.00,
                    isGlutenFree: true
                ),
                LeftoverItem(
                    name: "Vegetable Stir Fry",
                    quantity: 11,
                    price: 4.50,
                    isVegetarian: true,
                    isVegan: true,
                    isHalal: true,
                    isGlutenFree: true,
                ),
                LeftoverItem(
                    name: "Lamb Kebab",
                    quantity: 6,
                    price: 7.50,
                    isHalal: true,
                    isGlutenFree: true
                )
            ]
        )
    ]
}
