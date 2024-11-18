//
//  FoodCategoryEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

struct RestaurantCategory {
    let imageURL: String
    let name: String
    let id: Int
    
    static func from(dictionary: [String: Any]) -> RestaurantCategory? {
        guard
            let imageURL = dictionary["imageURL"] as? String,
            let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? Int
        else {
            return nil
        }
        
        return RestaurantCategory(imageURL: imageURL, name: name, id: id)
    }
}
