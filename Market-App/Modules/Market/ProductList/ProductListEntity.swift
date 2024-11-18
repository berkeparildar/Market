//
//  ProductListingEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

class Category {
    let name: String
    let products: [Product]
    let id: Int
    
    init(name: String, products: [Product], id: Int) {
        self.name = name
        self.products = products
        self.id = id
    }
    
    static func from(dictionary: [String: Any]) -> Category? {
        guard
            let name = dictionary["name"] as? String,
            let products = dictionary["products"] as? [[String: Any]],
            let id = dictionary["id"] as? Int
        else {
            return nil
        }
        var productArray: [Product] = []
        for product in products {
            guard let product = Product.from(dictionary: product) else {
                print("Unable to parse product dictionary: \(product)")
                return Category(name: name, products: [], id: 0)
            }
            productArray.append(product)
        }
        
        return Category(name: name, products: productArray, id: id)
    }
}


