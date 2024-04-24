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
    func isCartEmpty() -> Bool
}

/*This singleton service handles all cart related operations across the entire application, 
 and uses DataManager to save the changes made to CoreData*/
final class CartService {
    
    static let shared = CartService()
    private let dataManager = DataManager() // DataManager to save changes to CoreData
    private var productsInCart: [Product] = [] // This array acts as a cart during runtime
    
    init() {
        // The data is fetched during the initialization, and saved to the productsInCart array
        productsInCart = dataManager.fetchCart()
    }
    
}

extension CartService: CartServiceProtocol {
    
    /* Function for adding a product to cart. Tells DataManager to update the product data in the CoreData
     Checks if productsInCart array contains the product in the parameter.
     If it does exist, increases the quantityInCart attribute of the product in the array by one.
     If it does not, it adds the given product to the array.
     *quantityInCart is an integer value of Product Model that represents how many of that product that cart has
     *Product conforms to Equatable by comparing id's */
    func addProductToCart(product: Product) {
        dataManager.addProductToCart(product: product)
        if let index = productsInCart.firstIndex(where: { $0 == product }) {
            productsInCart[index].quantityInCart += 1
        }
        else {
            /* One thing to note here is that if the given product already has its isInCart and quantityInCart
            values updated, since it is updated in the view, so updating those values here are not needed*/
            productsInCart.append(product)
        }
    }
    
    /* Function for removing a product from cart. Tells DataManager to update the product data in the CoreData
     Checks if productsInCart array contains the product in the parameter.
     Decreases the quantityInCart attribute of the product in the array by one.
     If it is 0, updates its isInCart attribute to false. */
    func removeProductFromCart(product: Product) {
        if let index = productsInCart.firstIndex(where: { $0 == product }) {
            productsInCart[index].quantityInCart -= 1
            if productsInCart[index].quantityInCart == .zero {
                productsInCart.remove(at: index)
            }
        }
        dataManager.removeProductFromCart(product: product)
    }
    
    // Function for returning products that are currently in the cart. Used by Interactor of the Cart Module.
    func getProductsInCart() -> [Product] {
        return productsInCart
    }
    
    /* Function for checking if cart has any products. Used by CustomNavigationBarController to update the
    cart buttons visibility. */
    func isCartEmpty() -> Bool {
        return productsInCart.isEmpty
    }
    
    /* Function for calculating the total cost of cart. Used by CustomNavigationBarController to update the
    price in the cart button. */
    func totalPrice() -> Double {
        var totalPrice = 0.0
        self.productsInCart.forEach {
            totalPrice += $0.productPrice * Double($0.quantityInCart)
        }
        return totalPrice
    }
    
    /* Function for removing all the products in cart. Used for completed orders and the Trash Button for Cart Page */
    func clearProductsInCart() {
        dataManager.clearCart()
        productsInCart.removeAll()
    }
    
    /* Function for updating the cart status of the given products. By cart status, the products' isInCart and
     quantityInCart values are updated to match the current status of cart. Used by ProductListing module to sync
     these values across pages. */
    func updateCartStatusOfProducts(products: [Product]) -> [Product] {
        var updatedProducts = [Product]()
        for product in products {
            if let match = productsInCart.first(where: { $0 == product }) {
                updatedProducts.append(match)
            }
            else {
                updatedProducts.append(Product(id: product.id, productName: product.productName, productDescription: product.productDescription, productPrice: product.productPrice, productPriceText: product.productPriceText, isInCart: false, quantityInCart: 0, imageURL: product.imageURL))
            }
        }
        return updatedProducts
    }
    
}
