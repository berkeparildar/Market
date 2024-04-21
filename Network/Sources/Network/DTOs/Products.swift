//
//  Product.swift
//
//
//  Created by Berke Parıldar on 21.04.2024.
//

import Foundation

public struct ProductAPIResponse: Decodable {
    var id: String?
    var name: String?
    var productCount: Int?
    var products: [ProductAPI]?
}

public struct SuggestedProductAPIResponse: Decodable {
    var id: String?
    var name: String?
    var products: [ProductAPI]?
}

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
