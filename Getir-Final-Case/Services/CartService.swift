//
//  CartService.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 21.04.2024.
//

import Foundation

protocol CartServiceProtocol {
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
    func getProductsInCart() -> [Product]
    func getProductFromCartWithID(id: String) -> Product?
    func isCartEmpty() -> Bool
}

final class CartService {
    static let shared = CartService()
    private let dataManager = DataManager()
    private var productsInCart: [Product] = []
    
    init() {
        productsInCart = dataManager.fetchCart()
    }
    
}

extension CartService: CartServiceProtocol {
    func addProductToCart(product: Product) {
        dataManager.addProductToCart(product: product)
        if let index = productsInCart.firstIndex(where: { $0.id == product.id }) {
            productsInCart[index].inCartCount += 1
        }
        else {
            productsInCart.append(product)
        }
    }
    
    func removeProductFromCart(product: Product) {
        if let index = productsInCart.firstIndex(where: { $0.id == product.id }) {
            productsInCart[index].inCartCount -= 1
            if productsInCart[index].inCartCount == 0 {
                productsInCart.remove(at: index)
            }
        }
        dataManager.removeProductFromCart(product: product)
    }
    
    func getProductsInCart() -> [Product] {
        return productsInCart
    }
    
    func isCartEmpty() -> Bool {
        return productsInCart.isEmpty
    }
    
    func getProductFromCartWithID(id: String) -> Product? {
        let product = dataManager.fetchProductWithID(id: id)
        return product
    }
    
    func clearProductsInCart() {
        productsInCart.removeAll()
        
    }
    
    func updateCartStatusOfProducts(products: [Product]) -> [Product] {
        var updatedProducts = [Product]()
        for product in products {
            if let match = productsInCart.first(where: { $0.id == product.id}) {
                updatedProducts.append(match)
            }
            else {
                updatedProducts.append(Product(id: product.id, productName: product.productName, productDescription: product.productDescription, productPrice: product.productPrice, productPriceText: product.productPriceText, isInCart: false, inCartCount: 0, imageURL: product.imageURL))
            }
        }
        return updatedProducts
    }
    
}
