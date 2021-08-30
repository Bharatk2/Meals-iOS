//
//  Category.swift
//  FreeMeals
//
//  Created by Bharat Kumar on 8/16/21.
//

import Foundation

/// The struct ``Categories`` will access categories array to decode all the categories in the networking implementation, this is the first step of the project.
struct Categories: Codable {
    var categories: [Category]
    
    enum CodingKeys: String, CodingKey {
        case categories
    }
    
    struct Category: Codable {
        var id: String
        var category: String
        var categoryThumb: String
        
        enum CategoryKeys: String, CodingKey {
            case id = "idCategory"
            case category = "strCategory"
            case categoryThumb = "strCategoryThumb"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CategoryKeys.self)
            id = try container.decode(String.self, forKey: .id)
            category = try container.decode(String.self, forKey: .category)
            categoryThumb = try container.decode(String.self, forKey: .categoryThumb)
        }
    }
}
