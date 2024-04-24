//
//  NetworkProductResponse.swift
//
//
//  Created by Berke Parıldar on 24.04.2024.
//

import Foundation

public struct NetworkProductResponse: Decodable {
    public var results: [ProductAPI]
    
    private enum RootCodingKeys: String, CodingKey {
        case products
    }
    
    public init(from decoder: Decoder) {
        self.results = [ProductAPI]()
        do {
            let container = try decoder.container(keyedBy: RootCodingKeys.self)
            self.results = try container.decode([ProductAPI].self, forKey: .products)
        }
        catch {
           
        }
    }
}

