//
//  Meal.swift
//  FreeMeals
//
//  Created by Bharat Kumar on 8/16/21.
//

import Foundation

/// The Struct ``Meals`` will access the meals array to decode, which is the second step of networking call implementation.
struct Meals: Codable {
    var meals: [Meal]
    
    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }
    
    struct Meal: Codable {
        let mealName: String?
        let mealThumb: String?
        let id: String
        
        enum MealKeys: String, CodingKey {
            case mealName = "strMeal"
            case mealThumb = "strMealThumb"
            case id = "idMeal"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MealKeys.self)
            mealName = try container.decodeIfPresent(String.self, forKey: .mealName)
            mealThumb = try container.decodeIfPresent(String.self, forKey: .mealThumb)
            id = try container.decode(String.self, forKey: .id)
            
        }
    }
}

/// The Struct ``MealDetail`` is the third step for networking implementation once we have the existing meal id.
struct MealDetail: Codable {
    let id: String
    let mealName: String
    let category: String
    let instructions: String
    let mealThumb: String
    let ingredients: [MealIngredients]
    
}
/// The Struct ``MealIngredients`` had to be separated from ``MealDetail`` struct. Because there are multiple meal ingredients and measurements that we need to handle.
struct MealIngredients: Codable {
    let name: String
    let quantity: String
}



