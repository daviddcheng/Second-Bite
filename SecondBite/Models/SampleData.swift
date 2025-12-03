import Foundation
import Combine

enum SampleData {
    static let halls: [DiningHall] = [
        DiningHall(
            name: "1920 Commons",
            description: "Large central dining hall with a wide variety of classic and rotating options right by the Quad.",
            latitude: 39.95239,
            longitude: -75.19935,
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
            latitude: 39.95278,
            longitude: -75.19068,
            leftovers: [
                LeftoverItem(
                    name: "Veggie Pasta Bar",
                    quantity: 10,
                    price: 5.50,
                    isVegetarian: true,
                    isVegan: true
                ),
                LeftoverItem(
                    name: "Gluten-Free Brownies",
                    quantity: 8,
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
            ],
            imageName: "HillHouse"
        ),
        
        DiningHall(
            name: "English House",
            description: "Fresh, modern dining hall on the east side of campus with lots of salad and grill options.",
            latitude: 39.954193,
            longitude: -75.193901,
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
            latitude: 39.95391,
            longitude: -75.19097,
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
            latitude: 39.95323,
            longitude: -75.20025,
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
        ),

        DiningHall(
            name: "Houston Market",
            description: "A large food court in Houston Hall with many quick-service options including sushi, salads, grill items, and more.",
            latitude: 39.950999,
            longitude: -75.193881,
            leftovers: [
                LeftoverItem(name: "Sushi Rolls", quantity: 10, isVegetarian: false),
                LeftoverItem(name: "Veggie Rice Bowls", quantity: 7, isVegetarian: true)
            ],
            imageName: "Houston"
        ),
        
        DiningHall(
            name: "Quaker Kitchen (Gutmann College House)",
            description: "A community-focused teaching kitchen in Gutmann College House offering group meals and culinary events.",
            latitude: 39.953861,
            longitude: -75.202553,
            leftovers: [
                LeftoverItem(name: "Family-Style Pasta", quantity: 5, isVegetarian: true),
                LeftoverItem(name: "Roasted Veggies", quantity: 8, isVegetarian: true, isVegan: true)
            ],
            imageName: "Quaker"
        ),

        DiningHall(
            name: "Pret A Manger (Huntsman Hall)",
            description: "Campus location of Pret A Manger inside Huntsman Hall offering sandwiches, wraps, soups, and coffee.",
            latitude: 39.952872,
            longitude: -75.198425,
            leftovers: [
                LeftoverItem(name: "Wraps", quantity: 6),
                LeftoverItem(name: "Fruit Cups", quantity: 12, isVegetarian: true, isVegan: true)
            ],
            imageName: "Pret"
        ),

        DiningHall(
            name: "McClelland Express (The Quad)",
            description: "Grab-and-go dining inside the lower Quad featuring late-night snacks and essentials.",
            latitude: 39.950446,
            longitude: -75.197039,
            leftovers: [
                LeftoverItem(name: "Spicy-Tuna Roll", quantity: 9),
                LeftoverItem(name: "Pork Udon", quantity: 14)
            ],
            imageName: "Mcklend"
        )
    ]
}
