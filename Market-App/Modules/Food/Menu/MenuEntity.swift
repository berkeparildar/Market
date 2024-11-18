//
//  MenuEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

struct Menu {
    let id: Int
    let name: String
    let price: Double
    let description: String
    let imageURL: String
    let options: [MenuOption]
    
    
    static func from(dictionary: [String: Any]) -> Menu? {
        guard
            let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let price = dictionary["price"] as? Double,
            let imageURL = dictionary["imageURL"] as? String
        else {
            return nil
        }
        let options = dictionary["options"] as? [[String: Any]] ?? []
        let description = dictionary["description"] as? String ?? ""
        var menuOptions: [MenuOption] = []
        for option in options {
            guard let menuOption = MenuOption.from(dictionary: option) else { return nil }
            menuOptions.append(menuOption)
        }
        
        return Menu(
            id: id,
            name: name,
            price: price,
            description: description,
            imageURL: imageURL,
            options: menuOptions
        )
    }
    
}
