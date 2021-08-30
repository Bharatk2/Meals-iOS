//
//  ModelController.swift
//  FreeMeals
//
//  Created by Bharat Kumar on 8/16/21.
//

import Foundation
import CoreData
import UIKit

enum NetworkError: Error {
    case noData(String), badData(String)
    case failedFetch(String), badURL(String)
    case badError(String)
}

class ModelController {
    
    // MARK: - Properties
    var categories: [Categories.Category] = []
    var meals: [Meals.Meal] = []
    private var imageCache = Cache<NSString, AnyObject>()
    private var dataLoader: DataLoader?
    static var shared = ModelController()
    
    // MARK: - Computed Properties
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // MARK: - Initializer
    init(dataLoader: DataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
    }
    
    /// Networking method for categories
    /// - Parameter completion: completion function has categories that will be assigned to an empty categories array if the call succeeds.
    func getCategories(completion: @escaping (Categories?, Error?) -> Void) {
        let requestURL = Endpoints.categories.url
        var request = URLRequest(url: requestURL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataLoader?.loadData(from: request, completion: { data, response, error in
            
            if let response = response as? HTTPURLResponse {
                NSLog("Server responded with: \(response.statusCode)")
            }
            
            if let error = error {
                completion(nil, error)
            }
            
            guard let data = data else {
                completion(nil, NetworkError.badData("No data was returned"))
                return
            }
            
            let categories = Categories.self
            // we know this place can throw an error so it's important to use do and catch in which we can identify what area of the app failed.
            do {
                let categories = try self.decoder.decode(categories, from: data)
                self.categories = categories.categories
                // if it succeeds it will populate the categories and show error nil
                return completion(categories, nil)
            } catch {
                return completion(nil, NetworkError.badData("there was an error decoding data"))
            }
        })
    }
    
    /// Networking  method for meals by category
    /// - Parameters:
    ///   - category: Categories.Category is the struct
    ///   - completion: completion function has meals which will be assinged to a meal array if fetching calls succeeds.
    func getMeals(category: String,completion: @escaping (Meals?, Error?) -> Void) {
        
        let requestURL = Endpoints.meals(category).url
        var request = URLRequest(url: requestURL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataLoader?.loadData(from: request, completion: { data, response, error in
            if let response = response as? HTTPURLResponse {
                NSLog("Server responded with: \(response.statusCode)")
            }
            
            if let error = error {
                completion(nil, error)
            }
            
            guard let data = data else {
                completion(nil, NetworkError.badData("No data was returned for meals"))
                return
            }
            
            let meals = Meals.self
            // we know this place can throw an error so it's important to use do and catch in which we can identify what area of the app failed.
            do {
                let meals = try self.decoder.decode(meals, from: data)
                
                self.meals = meals.meals
                return completion(meals, nil)
                
            } catch {
                return completion(nil, NetworkError.badData("there was an error decodig meal data "))
            }
            
        })
        
    }
    
    /// Networking function for meals details like instructions, ingredients, measures in detail view.
    /// - Parameters:
    ///   - mealID: The meal id to get full access of meal details
    ///   - completion: Completion handler takes mealDetail as parameter which determines if fetching call succeeded or not.
    func getMealsById(mealID: String,completion: @escaping (MealDetail?, Error?) -> Void) {
        
        let requestURL = Endpoints.mealsDetail(mealID).url
        var request = URLRequest(url: requestURL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataLoader?.loadData(from: request, completion: { data, response, error in
            if let response = response as? HTTPURLResponse {
                NSLog("Server responded with: \(response.statusCode)")
            }
            
            if let error = error {
                completion(nil, error)
            }
            
            guard let data = data else {
                completion(nil, NetworkError.badData("No data was returned for meals"))
                return
            }
            /*
             I tried using Codable but I had to trade it with JSONSerialization since I found it easier to build an array of ingredients and make logic statements.
             because the way the API structured its data isn't set up the best,
             since there are many properties for ingredients and measures. JSONSerialization was the best way to make an array with if
             statement to determine an existing value and convert it to an array of ingredients.
             */
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let meals = json["meals"] as? [[String: Any]],
               let mealName = meals[0]["strMeal"] as? String, meals.count > 0 {
                // if there is an empty string we can set it to empty string as default
                let id = meals[0]["idMeal"] as? String ?? ""
                let category = meals[0]["strCategory"] as? String ?? ""
                let instructions = meals[0]["strInstructions"] as? String ?? ""
                let mealThumb = meals[0]["strMealThumb"] as? String ?? ""
                
                
                var ingredients: [MealIngredients] = []
                /* here we are making a for loop of int which will iterate till 20 adding it to "strIngredient".
                 So we don't have to make multiple ingredient properties with number and same with measures.
                 */
                for number in 1...20 {
                    let ingredient = meals[0]["strIngredient\(number)"] as? String ?? ""
                    // there could be some ingredient properties that can be empty, so we are checking that with if statement.
                    if ingredient != "" {
                        let measure = meals[0]["strMeasure\(number)"] as? String ?? ""
                        let mealIngredients = MealIngredients(name: ingredient, quantity: measure)
                        ingredients.append(mealIngredients)
                    }
                }
                // We have the data we are required we will add it to the mealdetail struct and add it to completion
                let meal = MealDetail(id: id, mealName: mealName, category: category, instructions: instructions, mealThumb: mealThumb, ingredients: ingredients)
                
                DispatchQueue.main.async {
                    completion(meal, nil)
                }
                
            }
        })
        
    }
    
    //MARK: - Get Image Instructions
    /*
     All we need to do is call this function in the view controller cell,
     assign the imageURL to the offerImageURL
     and assign  completion image to the outlet image
     */
    func getImages(imageURL: String, completion: @escaping (UIImage?, Error?) -> Void) {
        
        let imageString = NSString(string: imageURL)
        if let imageFromCache = imageCache.value(for: imageString) as? UIImage {
            completion(imageFromCache, nil)
            return
        }
        guard let imageURL = URL(string: imageURL) else {
            return completion(nil, NetworkError.badURL("The url for image was incorrect"))
        }
        
        dataLoader?.loadData(from: imageURL, completion: { data, _, error in
            if let error = error {
                NSLog("error in fetching image :\(error)")
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil, NetworkError.badData("there was an error in image data"))
                return
            }
            
            self.imageCache.cache(value: image, for: imageString)
            completion(image, nil)
            
        })
    }
    
    
}
