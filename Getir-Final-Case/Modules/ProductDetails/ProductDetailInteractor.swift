//
//  ProductDetailInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductDetailInteractorProtocol {
    func fetchProductStatus()
}

protocol ProductDetailInteractorOutputProtocol {
    func fetchProductStatus()
}

final class ProductDetailInteractor {
    var output: ProductDetailInteractorOutputProtocol?
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    func fetchProductStatus() {
        
    }
}
