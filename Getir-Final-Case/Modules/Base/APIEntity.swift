//
//  APIEntities.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

class ProductAPIResponse: Decodable {
    var id: String?
    var name: String?
    var productCount: Int?
    var products: [ProductAPI]?
}

class SuggestedProductAPIResponse: Decodable {
    var id: String?
    var name: String?
    var products: [ProductAPI]?
    
    init(id: String? = nil, name: String? = nil, products: [ProductAPI]? = nil) {
        self.id = id
        self.name = name
        self.products = products
    }
}

class ProductAPI: Decodable {
    var id: String?
    var name: String?
    var attribute: String?
    var shortDescription: String?
    var squareThumbnailURL: URL?
    var thumbnailURL: URL?
    var imageURL: URL?
    var price: Double?
    var priceText: String?
    var imageData: Data?
    
    init(id: String? = nil, name: String? = nil, attribute: String? = nil, shortDescription: String? = nil, squareThumbnailURL: URL? = nil, thumbnailURL: URL? = nil, imageURL: URL? = nil, price: Double? = nil, priceText: String? = nil, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.attribute = attribute
        self.shortDescription = shortDescription
        self.squareThumbnailURL = squareThumbnailURL
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
        self.price = price
        self.priceText = priceText
        self.imageData = imageData
    }
}
