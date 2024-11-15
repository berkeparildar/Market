//
//  MarketCartService.swift
//  Market-App
//
//  Created by Berke Parıldar on 13.11.2024.
//

final class MarketCartService {
    
    static let shared = MarketCartService()
    
    private init() {}
    
    var productsInCart: [MarketCartEntity] = []
    
    func addProductToCart(product: Product) {
        if let product = productsInCart.first(where: { $0.product.id == product.id }) {
            product.quantity += 1
        } else {
            let cartProduct = MarketCartEntity(product: product)
            productsInCart.append(cartProduct)
        }
    }
    
    func removeProductFromCart(product: Product) {
        print(productsInCart.count)
        if let product = productsInCart.first(where: { $0.product.id == product.id }) {
            if product.quantity > 1 {
                product.quantity -= 1
            } else {
                productsInCart.removeAll { $0.product.id == product.product.id }
            }
        }
    }
    
    func getCartProducts() -> [MarketCartEntity] {
        return productsInCart
    }
    
    func getTotalPrice() -> Double {
        var totalPrice: Double = 0
        for product in productsInCart {
            totalPrice += product.product.productPrice * Double(product.quantity)
        }
        return totalPrice
    }
    
    func clearCart() {
        productsInCart.removeAll()
    }
    
    func getProductQuantity(product: Product) -> Int {
        return productsInCart.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }
}
