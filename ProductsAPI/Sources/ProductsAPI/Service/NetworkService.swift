//
//  NetworkService.swift
//
//
//  Created by Berke Parıldar on 24.04.2024.
//

import Foundation
import Moya


enum NetworkService {
    case getCategories
    case getProducts(categoryName: String)
    case getProductsWithID(categoryID: Int)
}

enum NetworkError: Error {
    case unknown
}

extension NetworkService: TargetType {
    var baseURL: URL {
        URL(string: "http://localhost:5274/api")!
    }
    
    var path: String {
        switch self {
        case .getCategories:
            return "/categories"
        case .getProducts(let categoryName):
            return "/products/\(categoryName)"
        case .getProductsWithID(let id):
            return "/products/id\(id)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

