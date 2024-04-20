//
//  CartInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

protocol CartInteractorProtocol: AnyObject {
    func fetchProductsInCart()
    func fetchSuggestedProducts()
    func productAddedToCart(product: Product)
    func productRemovedFromCart(product: Product)
}

protocol CartInteractorOutputProtocol: AnyObject {
    func fetchProductsInCartOutput(result: [Product])
    func fetchSuggestedProductsOutput(result: [Product])
}

final class CartInteractor {
    var output: CartInteractorOutputProtocol?
    var suggestedProducts: [Product]?
}

extension CartInteractor: CartInteractorProtocol {
    
    func fetchProductsInCart() {
        let products = ProductService.shared.fetchCartProducts()
        self.output?.fetchProductsInCartOutput(result: products)
    }
    
    func fetchSuggestedProducts() {
        if let suggestedProducts = self.suggestedProducts {
            self.output?.fetchSuggestedProductsOutput(result: suggestedProducts)
        } else {
            ProductService.shared.fetchSuggestedProducts { products in
                self.output?.fetchSuggestedProductsOutput(result: products)
            }
        }
    }
    
    func productAddedToCart(product: Product) {
        ProductService.shared.removeFromCart(product: product)
    }
    
    func productRemovedFromCart(product: Product) {
        ProductService.shared.removeFromCart(product: product)
    }
}
