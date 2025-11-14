import Foundation

extension MockData {
    static let foodEntries: [FoodEntry] = [
        FoodEntry(food: oatmeal, servingSize: 150, mealType: .breakfast),
        FoodEntry(food: banana, servingSize: 120, mealType: .breakfast),
        FoodEntry(food: greekYogurt, servingSize: 200, mealType: .breakfast),
        FoodEntry(food: wholeWheatBread, servingSize: 80, mealType: .breakfast),
        FoodEntry(food: peanutButter, servingSize: 30, mealType: .breakfast),
        FoodEntry(food: orange, servingSize: 100, mealType: .breakfast),

        FoodEntry(food: proteinFood, servingSize: 180, mealType: .lunch),
        FoodEntry(food: rice, servingSize: 150, mealType: .lunch),
        FoodEntry(food: broccoli, servingSize: 100, mealType: .lunch),
        FoodEntry(food: firmTofu, servingSize: 150, mealType: .lunch),
        FoodEntry(food: pasta, servingSize: 200, mealType: .lunch),
        FoodEntry(food: spinach, servingSize: 100, mealType: .lunch),
        FoodEntry(food: tomato, servingSize: 80, mealType: .lunch),
        FoodEntry(food: almonds, servingSize: 25, mealType: .lunch),

        FoodEntry(food: grilledSalmon, servingSize: 160, mealType: .dinner),
        FoodEntry(food: sweetPotato, servingSize: 200, mealType: .dinner),
        FoodEntry(food: carrots, servingSize: 100, mealType: .dinner),
        FoodEntry(food: leanBeef, servingSize: 170, mealType: .dinner),
        FoodEntry(food: rice, servingSize: 150, mealType: .dinner),
        FoodEntry(food: avocado, servingSize: 70, mealType: .dinner),
        FoodEntry(food: darkChocolate, servingSize: 20, mealType: .dinner)
    ]
}
