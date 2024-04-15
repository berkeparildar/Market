//
//  ProductDetailInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductDetailInteractorProtocol {
    func productAddedToCart()
    func productRemovedFromCart()
    func getProduct()
}

protocol ProductDetailInteractorOutputProtocol {
    func product(product: Product)
}

final class ProductDetailInteractor {
    var output: ProductDetailInteractorOutputProtocol?
    var product: Product?
    
    init(product: Product? = nil) {
        self.product = product
    }
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    
    func getProduct() {
        guard let product = self.product else { return }
        self.output?.product(product: product)
    }
    
    func productAddedToCart() {
        guard let product = product, let id = product.id, let price = product.price else { return }
        CartRepository.shared.updateProduct(id: id, price: price, add: true)
    }
    
    func productRemovedFromCart() {
        guard let product = product, let id = product.id, let price = product.price else { return }
        CartRepository.shared.updateProduct(id: id, price: price, add: false)
    }
}
