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
    var isInCart: Bool
    var inCartCount: Int
    var imageURL: URL
    
}
