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
    
    static func from(dictionary: [String: Any]) -> Product? {
        guard
            let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let productPrice = dictionary["price"] as? Double,
            let productPriceText = dictionary["priceText"] as? String,
            let image = dictionary["image"] as? String
        else {
            return nil
        }
        return Product(id: id,
                       name: name,
                       description: description,
                       productPrice: productPrice,
                       productPriceText: productPriceText,
                       imageURL: image)
    }
}
