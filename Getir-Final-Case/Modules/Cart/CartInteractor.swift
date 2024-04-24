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
    
    /* Tells Cart Service to to clear the cart. */
    func clearCart() {
        CartService.shared.clearProductsInCart()
    }
    
    /* Tells Cart Service fetch the current products in cart. For safety measure, Cart
     View is the only page that fetches these products directly from Cart Service. */
    func fetchProductsInCart() {
        let products = CartService.shared.getProductsInCart()
        self.output?.fetchProductsInCartOutput(result: products)
    }
    
    /* Checks if suggested product is nil, which happens if its been navigated from
     product detail page, if it is, uses ProductService to fetch it from online, if not,
     uses the one passes from product listing
     */
    func fetchSuggestedProducts() {
        if let suggestedProducts = self.suggestedProducts {
            self.output?.fetchSuggestedProductsOutput(result: suggestedProducts)
        } else {
            ProductService.shared.getSuggestedProducts { products in
                self.output?.fetchSuggestedProductsOutput(result: products)
            }
        }
    }
    
    /*Functions for adding or removing products from cart via CartService*/
    func addProductToCart(product: Product) {
        CartService.shared.addProductToCart(product: product)
    }
    
    func removeProductFromCart(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
    }
    
}
