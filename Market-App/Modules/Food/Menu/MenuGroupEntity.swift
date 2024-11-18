//
//  MenuListEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

struct MenuGroup {
    let title: String
    let menus: [Menu]
    
    static func from(dictionary: [String: Any]) -> MenuGroup? {
        guard
            let title = dictionary["title"] as? String
        else {
            return nil
        }

        let menus = dictionary["menus"] as? [[String: Any]] ?? []
        var menuobjects: [Menu] = []
        
        for menu in menus {
            if let menuObject = Menu.from(dictionary: menu) {
                menuobjects.append(menuObject)
            }
        }
        
        return MenuGroup(title: title, menus: menuobjects)
        
    }
}
