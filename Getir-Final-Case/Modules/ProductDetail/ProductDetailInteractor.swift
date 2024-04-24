//
//  ProductDetailInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductDetailInteractorProtocol {
    func fetchProduct()
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
}

protocol ProductDetailInteractorOutputProtocol {
    func product(product: Product)
}

final class ProductDetailInteractor {
    var output: ProductDetailInteractorOutputProtocol?
    var product: Product!
    
    init(product: Product) {
        self.product = product
    }
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    
    /* Function for forwarding the given product to the presenter */
    func fetchProduct() {
        self.output?.product(product: product)
    }
    
    /* Tells Cart Service to add the given product to cart, called when the  buttons are tapped from the
     button block at the bottom*/
    func addProductToCart(product: Product) {
        CartService.shared.addProductToCart(product: product)
    }
    
    /* Tells Cart Service to remove the given product to cart, called when the  buttons are tapped from the
     button block at the bottom*/
    func removeProductFromCart(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
    }
    
}
