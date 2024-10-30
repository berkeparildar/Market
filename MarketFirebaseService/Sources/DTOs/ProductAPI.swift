//
//  ProductAPI.swift
//  
//
//  Created by Berke Parıldar on 29.10.2024.
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
