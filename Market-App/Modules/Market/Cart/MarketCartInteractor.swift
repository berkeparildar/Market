//
//  MarketCartInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

protocol MarketCartInteractorProtocol: AnyObject {
    func getCartProducts()
    func getSuggestedProducts()
    func clearCart()
    func getCurrentAddress() -> String
}

protocol MarketCartInteractorOutputProtocol: AnyObject {
    func getCartProductsOutput(products: [MarketCartEntity])
    func getSuggestedProductsOutput(products: [Product])
}

final class MarketCartInteractor {
    var output: MarketCartInteractorOutputProtocol?
}

extension MarketCartInteractor: MarketCartInteractorProtocol {
    func getCurrentAddress() -> String {
        let savedAddressIndex = UserService.shared.getSavedAddressIndex()
        let currentUser = UserService.shared.getCurrentUser()!
        if !currentUser.addresses.isEmpty {
            return currentUser.addresses[savedAddressIndex].addressText
        }
        return ""
    }
    
    func clearCart() {
        MarketCartService.shared.clearCart()
    }
    
    func getCartProducts() {
        let cartContents = MarketCartService.shared.getCartProducts()
        output?.getCartProductsOutput(products: cartContents)
    }
    
    func getSuggestedProducts() {
        let cartContents = MarketCartService.shared.getCartProducts().map { $0.product }
        if cartContents.isEmpty {
            return
        }
        var categoryCounter: [Int: Int] = [:]
        for product in cartContents {
            categoryCounter[product.categoryID] = (categoryCounter[product.categoryID] ?? 0) + 1
        }
        let sortedCategories = categoryCounter.sorted { $0.value > $1.value }
        let categoryID = sortedCategories.first?.key
        let suggestedProducts = ProductService.shared.getProductOfCategoryID(id: categoryID!)
        let filteredProducts = suggestedProducts.filter { product in
            let alreadyInCart = cartContents.contains { $0.id == product.id }
            return !alreadyInCart
        }
        output?.getSuggestedProductsOutput(products: filteredProducts)
    }
}
