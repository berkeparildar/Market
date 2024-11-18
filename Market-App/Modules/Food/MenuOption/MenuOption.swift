//
//  MenuOption.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

class MenuOption {
    let title: String
    let options: [String]
    var selectedOptionIndex: Int = -1
    
    static func from(dictionary: [String: Any]) -> MenuOption? {
        guard
            let title = dictionary["title"] as? String,
            let options = dictionary["options"] as? [String]
        else {
            return nil
        }
        
        return MenuOption(title: title, options: options)
    }
    
    init(title: String, options: [String]) {
        self.title = title
        self.options = options
    }
}
