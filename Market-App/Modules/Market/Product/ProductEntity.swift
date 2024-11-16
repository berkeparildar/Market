//
//  ProductEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 13.11.2024.
//

struct Product {
    let id: Int
    let name: String
    let description: String
    let productPrice: Double
    let productPriceText: String
    var imageURL: String
    let categoryID: Int
    
    static func from(dictionary: [String: Any]) -> Product? {
        guard let id = dictionary["id"] as? Int else {
            return nil
        }
        guard let name = dictionary["name"] as? String else {
            return nil
        }
        guard let description = dictionary["description"] as? String else {
            return nil
        }
        guard let productPrice = dictionary["price"] as? Double else {
            return nil
        }
        guard let productPriceText = dictionary["priceText"] as? String else {
            return nil
        }
        guard let image = dictionary["image"] as? String else {
            return nil
        }
        guard let categoryID = dictionary["categoryID"] as? Int else {
            return nil
        }
        return Product(id: id,
                       name: name,
                       description: description,
                       productPrice: productPrice,
                       productPriceText: productPriceText,
                       imageURL: image,
                       categoryID: categoryID)
    }
}
