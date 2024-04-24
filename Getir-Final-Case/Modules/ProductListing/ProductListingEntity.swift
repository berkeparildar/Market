//
//  ProductListingEntity.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import Foundation

struct Product {
    var id: String
    var productName: String
    var productDescription: String
    var productPrice: Double
    var productPriceText: String
    var isInCart: Bool  // Boolean value representing if the product is in the cart
    var quantityInCart: Int  // Integer value representing the current amount in the cart
    var imageURL: URL
}

extension Product: Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
