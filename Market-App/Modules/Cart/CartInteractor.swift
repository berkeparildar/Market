//
//  CartInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

protocol CartInteractorProtocol: AnyObject {
    func fetchProductsInCart()
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
    func clearCart(products: [Product])
}

protocol CartInteractorOutputProtocol: AnyObject {
    func fetchProductsInCartOutput(result: [Product])
    func fetchSuggestedProductsOutput(result: [Product])
}

final class CartInteractor {
    var output: CartInteractorOutputProtocol?
}

extension CartInteractor: CartInteractorProtocol {
    func clearCart(products: [Product]) {
        CartService.shared.clearProductsInCart(products: products)
    }
    
    func fetchProductsInCart() {
        let products = CartService.shared.getProductsInCart()
        if let popularCategoryID = mostPopularCategory(in: products) {
            ProductService.shared.getProductsFromCategory(id: popularCategoryID) { suggestedProducts in
                let filteredProducts = suggestedProducts.filter { suggestedProduct in
                    !products.contains(where: { $0.id == suggestedProduct.id })
                }
                self.output?.fetchSuggestedProductsOutput(result: filteredProducts)
            }
        }
        self.output?.fetchProductsInCartOutput(result: products)
    }
    
    func mostPopularCategory(in products: [Product]) -> String? {
        var categoryCount = [String: Int]()
        for product in products {
            categoryCount[product.categoryID, default: 0] += 1
        }
        return categoryCount.max { $0.value < $1.value }?.key
    }
    
    func addProductToCart(product: Product) {
        CartService.shared.addProductToCart(product: product)
    }
    
    func removeProductFromCart(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
    }
}
