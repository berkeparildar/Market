//
//  ProductListingEntity.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import Foundation

class ProductAPIResponse: Decodable {
    var id: String?
    var name: String?
    var productCount: Int?
    var products: [Product]?
}

class SuggestedProductAPIResponse: Decodable {
    var id: String?
    var name: String?
    var products: [Product]?
    
    init(id: String? = nil, name: String? = nil, products: [Product]? = nil) {
        self.id = id
        self.name = name
        self.products = products
    }
}

class Product: Decodable {
    var id: String?
    var name: String?
    var attribute: String?
    var shortDescription: String?
    var squareThumbnailURL: URL?
    var thumbnailURL: URL?
    var imageURL: URL?
    var price: Double?
    var priceText: String?
    var cartStatus: CartProduct?
    
    init(id: String? = nil, name: String? = nil, attribute: String? = nil, shortDescription: String? = nil, squareThumbnailURL: URL? = nil, thumbnailURL: URL? = nil, imageURL: URL? = nil, price: Double? = nil, priceText: String? = nil, cartStatus: CartProduct? = nil) {
        self.id = id
        self.name = name
        self.attribute = attribute
        self.shortDescription = shortDescription
        self.squareThumbnailURL = squareThumbnailURL
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
        self.price = price
        self.priceText = priceText
        self.cartStatus = cartStatus
    }
}

class CartProduct: Decodable {
    var id: String?
    var count: Int?
    var isInCart: Bool? = false
    var price: Double?
    
    init(id: String? = nil, count: Int? = nil, isInCart: Bool? = nil, price: Double? = nil) {
        self.id = id
        self.count = count
        self.isInCart = isInCart
        self.price = price
    }
}
