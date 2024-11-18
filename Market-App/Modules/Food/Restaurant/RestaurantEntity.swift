//
//  RestaurantEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

struct Restaurant {
    let id: Int
    let name: String
    let imageURL: String
    let categories: [Int]
    let workingHours: String
    let menuGroups: [MenuGroup]
    
    static func from(dictionary: [String: Any]) -> Restaurant? {
        guard
            let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let imageURL = dictionary["imageURL"] as? String,
            let categories = dictionary["categories"] as? [Int],
            let workingHours = dictionary["workingHours"] as? String
        else {
            return nil
        }
        
        let menuGroups = (dictionary["menuGroups"] as? [[String: Any]] ?? []).compactMap(MenuGroup.from)
        
        return Restaurant(
            id: id,
            name: name,
            imageURL: imageURL,
            categories: categories,
            workingHours: workingHours,
            menuGroups: menuGroups
        )
    }
}
