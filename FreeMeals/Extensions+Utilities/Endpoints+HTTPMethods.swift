//
//  Endpoints+HTTPMethods.swift
//  FreeMeals
//
//  Created by Bharat Kumar on 8/18/21.
//

import Foundation

/// the enum  ``Endpoints`` is used to store urls for networking call. Enum makes the values like url to be implemented in a cleaner way.
enum Endpoints {
    static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    case categories
    case meals(String)
    case mealsDetail(String)
    
    /// We are using switch for stringValue computed property by going through all the cases
    /// so we can add specific parameters like category to the url so we can fetch we need.
    var stringValue: String {
        switch self {
        case .categories:
            return Endpoints.baseURL + "categories.php"
        case .meals(let category):
            return Endpoints.baseURL + "filter.php?c=" + "\(category)"
        case .mealsDetail(let mealID):
            return Endpoints.baseURL + "lookup.php?i=" + "\(mealID)"
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}
