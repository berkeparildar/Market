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
    var product: Product!
    weak var navBarNotifier: UpdateNavigationBarProtocol?
    
    init(product: Product? = nil) {
        self.product = product
    }
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    
    func getProduct() {
        self.output?.product(product: product)
    }
    
    func productAddedToCart() {
        CartRepository.shared.updateProduct(product: self.product, quantityIncreased: true)
        navBarNotifier?.updateNavigationBar()
    }
    
    func productRemovedFromCart() {
        CartRepository.shared.updateProduct(product: self.product, quantityIncreased: false)
        navBarNotifier?.updateNavigationBar()
    }
}
