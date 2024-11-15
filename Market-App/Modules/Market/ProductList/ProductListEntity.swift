//
//  ProductListingEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

class Category {
    let name: String
    let products: [Product]
    
    init(name: String, products: [Product]) {
        self.name = name
        self.products = products
    }
    
    static func from(dictionary: [String: Any]) -> Category? {
        guard
            let name = dictionary["name"] as? String,
            let products = dictionary["products"] as? [[String: Any]]
        else {
            return nil
        }
        var productArray: [Product] = []
        for product in products {
            guard let product = Product.from(dictionary: product) else {
                return Category(name: name, products: [])
            }
            productArray.append(product)
        }
        
        return Category(name: name, products: productArray)
    }
}


