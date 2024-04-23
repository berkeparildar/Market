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
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
    func clearCart()
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
    
    func clearCart() {
        CartService.shared.clearProductsInCart()
    }
    
    func fetchProductsInCart() {
        let products = CartService.shared.getProductsInCart()
        self.output?.fetchProductsInCartOutput(result: products)
    }
    
    func fetchSuggestedProducts() {
        if let suggestedProducts = self.suggestedProducts {
            self.output?.fetchSuggestedProductsOutput(result: suggestedProducts)
        } else {
            ProductService.shared.getSuggestedProducts { products in
                self.output?.fetchSuggestedProductsOutput(result: products)
            }
        }
    }
    
    func addProductToCart(product: Product) {
        CartService.shared.addProductToCart(product: product)
    }
    
    func removeProductFromCart(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
    }
    
}
