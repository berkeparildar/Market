//
//  ProductListingEntity.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import Foundation

class Product {
    
    var id: String
    var productName: String
    var productDescription: String
    var productPrice: Double
    var productPriceText: String
    var isInCart: Bool
    var inCartCount: Int
    var imageURL: URL

    init(id: String, productName: String, productDescription: String, productPrice: Double, productPriceText: String, isInCart: Bool, inCartCount: Int, imageURL: URL) {
        self.id = id
        self.productName = productName
        self.productDescription = productDescription
        self.productPrice = productPrice
        self.productPriceText = productPriceText
        self.isInCart = isInCart
        self.inCartCount = inCartCount
        self.imageURL = imageURL
    }
}
