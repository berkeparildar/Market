//
//  ProductListingEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.04.2024.
//

import Foundation

class Product {
    var id: Int
    var productName: String
    var productDescription: String
    var productPrice: Double
    var productPriceText: String
    var isInCart: Bool
    var quantityInCart: Int 
    var imageURL: String
    var categoryID: String
    init(id: Int, productName: String, productDescription: String, productPrice: Double, productPriceText: String, isInCart: Bool, quantityInCart: Int, imageURL: String, categoryID: String) {
        self.id = id
        self.productName = productName
        self.productDescription = productDescription
        self.productPrice = productPrice
        self.productPriceText = productPriceText
        self.isInCart = isInCart
        self.quantityInCart = quantityInCart
        self.imageURL = imageURL
        self.categoryID = categoryID
    }
}

extension Product: Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

class Category {
    let id: Int
    let name: String
    let image: String
    let route: String
    var products: [Product]
    
    init(id: Int, name: String, image: String, route: String, products: [Product]) {
        self.id = id
        self.name = name
        self.image = image
        self.route = route
        self.products = products
    }
}
