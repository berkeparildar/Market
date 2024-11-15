//
//  ProductService.swift
//  Market-App
//
//  Created by Berke Parıldar on 20.04.2024.
//

import Foundation
import MarketFirebaseService

final class ProductService {
    private let firebaseService: FirebaseProductService!
    static let shared = ProductService()
    
    var marketCategories: [Category] = []
    
    private init() {
        firebaseService = FirebaseProductService()
    }
    
    func setProducts(completion: @escaping (Error?) -> Void) {
        firebaseService.fetchCategories { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                for category in categories {
                    let fetchedCategory = Category.from(dictionary: category)
                    guard let fetchedCategory = fetchedCategory else { return }
                    self.marketCategories.append(fetchedCategory)
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func getProducts() -> [Category] {
        return marketCategories
    }
}

