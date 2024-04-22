//
//  ProductDetailInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductDetailInteractorProtocol {
    func productAddedToCart(product: Product)
    func productRemovedFromCart(product: Product)
    func fetchProduct()
}

protocol ProductDetailInteractorOutputProtocol {
    func product(product: Product)
}

final class ProductDetailInteractor {
    var output: ProductDetailInteractorOutputProtocol?
    var productID: String!
    var product: Product!
    
    init(product: Product, productID: String) {
        self.product = product
        self.productID = productID
    }
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    
    func fetchProduct() {
        let productInCart = CartService.shared.getProductFromCartWithID(id: product.id)
        if let product = productInCart {
            self.output?.product(product: product)
        }
        else {
            self.output?.product(product: product)
        }
    }
    
    func productAddedToCart(product: Product) {
        CartService.shared.addProductToCart(product: product)
    }
    
    func productRemovedFromCart(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
    }
}
