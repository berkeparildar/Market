//
//  CartService.swift
//  Market-App
//
//  Created by Berke Parıldar on 21.04.2024.
//

import Foundation

protocol CartServiceProtocol {
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
    func getProductsInCart() -> [Product]
    func isCartEmpty() -> Bool
}

final class CartService {
    static let shared = CartService()
    private let dataManager = DataManager()
    private var productsInCart: [Product] = []
    init() { productsInCart = dataManager.fetchCart() }
}

extension CartService: CartServiceProtocol {
    func addProductToCart(product: Product) {
        if product.quantityInCart == 0 {
            product.isInCart = true
            productsInCart.append(product)
        }
        product.quantityInCart += 1
        dataManager.addProductToCart(product: product)
    }
    
    func removeProductFromCart(product: Product) {
        product.quantityInCart -= 1
        if product.quantityInCart == 0 {
            product.isInCart = false
            productsInCart.removeAll(where: { $0 == product })
        }
        dataManager.removeProductFromCart(product: product)
    }
    
    func getProductsInCart() -> [Product] {
        return productsInCart
    }

    func isCartEmpty() -> Bool {
        return productsInCart.isEmpty
    }

    func totalPrice() -> Double {
        var totalPrice = 0.0
        self.productsInCart.forEach {
            totalPrice += $0.productPrice * Double($0.quantityInCart)
        }
        return totalPrice
    }
    
    func clearProductsInCart(products: [Product]) {
        for i in 0..<products.count {
            products[i].quantityInCart = 0
            products[i].isInCart = false
        }
        dataManager.clearCart()
        productsInCart.removeAll()
    }
    
    func updateCartStatusOfProducts(categories: [Category]) {
        for category in categories {
            for i in 0..<category.products.count {
                if let match = productsInCart.first(where: { $0 == category.products[i] }) {
                    category.products[i] = match
                }
            }
        }
    }
}
