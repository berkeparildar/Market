//
//  Products.swift
//
//
//  Created by Berke Parıldar on 24.04.2024.
//

import Foundation

public struct ProductAPI: Decodable {
    public var id: Int?
    public var name: String?
    public var description: String?
    public var image: String?
    public var price: Double?
    public var priceText: String?
    public var categoryID: String?
}

public struct CategoryAPI: Decodable {
    public var id: Int?
    public var name: String?
    public var image: String?
    public var route: String?
}

