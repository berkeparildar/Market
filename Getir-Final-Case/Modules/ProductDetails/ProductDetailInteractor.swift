//
//  ProductDetailInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductDetailInteractorProtocol {
    func updateCartRepository(with id: String, add: Bool)
}

protocol ProductDetailInteractorOutputProtocol {
    func fetchProductStatus()
}

final class ProductDetailInteractor {
    var output: ProductDetailInteractorOutputProtocol?
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {

    
    func updateCartRepository(with id: String, add: Bool) {
        
    }
}
