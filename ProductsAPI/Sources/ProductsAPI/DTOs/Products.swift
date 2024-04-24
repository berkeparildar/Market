//
//  Products.swift
//
//
//  Created by Berke Parıldar on 24.04.2024.
//

import Foundation

// The model representing the response
public struct ProductAPIResponse: Decodable {
    var id: String?
    var name: String?
    var productCount: Int?
    var products: [ProductAPI]?
}

// The model representing the product's in the response
public struct ProductAPI: Decodable {
    public var id: String?
    public var name: String?
    public var attribute: String?
    public var shortDescription: String?
    public var squareThumbnailURL: URL?
    public var thumbnailURL: URL?
    public var imageURL: URL?
    public var price: Double?
    public var priceText: String?
    public var imageData: Data?
}

