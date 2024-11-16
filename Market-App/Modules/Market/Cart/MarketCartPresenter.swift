//
//  MarketCartPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

import Foundation

protocol MarketCartPresenterProtocol {
    func getCartProductCount() -> Int
    func getCartProduct(at index: Int) -> MarketCartEntity
    func didSelectCartProduct(at index: Int)
    func getSuggestedProductCount() -> Int
    func getSuggestedProduct(at index: Int) -> Product
    func updateCartStatus()
    func didTapBuyButton()
    func didTapTrashButton()
    func getCurrentAddress() -> String
}

final class MarketCartPresenter {
    private let view: MarketCartViewProtocol
    private let interactor: MarketCartInteractorProtocol
    private let router: MarketCartRouterProtocol
    
    private var products: [MarketCartEntity] = []
    private var suggestedProducts: [Product] = []
    
    init(view: MarketCartViewProtocol,
         interactor: MarketCartInteractorProtocol,
         router: MarketCartRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MarketCartPresenter: MarketCartPresenterProtocol {
    func getCurrentAddress() -> String {
        return interactor.getCurrentAddress()
    }
    
    func didTapTrashButton() {
        MarketCartService.shared.clearCart()
        router.navigate(to: .root)
    }
    
    func didTapBuyButton() {
        interactor.clearCart()
        router.navigate(to: .home)
    }
    
    func updateCartStatus() {
        interactor.getCartProducts()
        interactor.getSuggestedProducts()
    }
    
    func getCartProductCount() -> Int {
        return products.count
    }
    
    func getCartProduct(at index: Int) -> MarketCartEntity {
        return products[index]
    }
    
    func didSelectCartProduct(at index: Int) {
        
    }
    
    func getSuggestedProductCount() -> Int {
        return suggestedProducts.count
    }
    
    func getSuggestedProduct(at index: Int) -> Product {
        return suggestedProducts[index]
    }
    
}

extension MarketCartPresenter: MarketCartInteractorOutputProtocol {
    func getCartProductsOutput(products: [MarketCartEntity]) {
        
        if products.isEmpty {
            router.navigate(to: .root)
        }
        
        let oldProducts = self.products
        let newProducts = products
        
        var addedIndices: [IndexPath] = []
        var removedIndices: [IndexPath] = []
        
        for (index, oldProduct) in oldProducts.enumerated() {
            if !newProducts.contains(where: { $0.product.id == oldProduct.product.id }) {
                removedIndices.append(IndexPath(item: index, section: 0))
            }
        }
        
        for (index, newProduct) in newProducts.enumerated() {
            if !oldProducts.contains(where: { $0.product.id == newProduct.product.id }) {
                addedIndices.append(IndexPath(item: index, section: 0))
            }
        }
        
        self.products = products
        
        if !removedIndices.isEmpty {
            view.deleteItems(at: removedIndices)
        }
        if !addedIndices.isEmpty {
            view.insertItems(at: addedIndices)
        }
        if addedIndices.isEmpty && removedIndices.isEmpty {
            view.reloadData()
        }
        
        var totalPrice = 0.0
        for product in products {
            totalPrice += product.product.productPrice * Double(product.quantity)
        }
        view.updatePriceLabel(price: totalPrice)
    }
    
    func getSuggestedProductsOutput(products: [Product]) {
        let oldProducts = self.suggestedProducts
        let newProducts = products
        
        var addedIndices: [IndexPath] = []
        var removedIndices: [IndexPath] = []
        
        for (index, oldProduct) in oldProducts.enumerated() {
            if !newProducts.contains(where: { $0.id == oldProduct.id }) {
                removedIndices.append(IndexPath(item: index, section: 1))
            }
        }
        
        for (index, newProduct) in newProducts.enumerated() {
            if !oldProducts.contains(where: { $0.id == newProduct.id }) {
                addedIndices.append(IndexPath(item: index, section: 1))
            }
        }
        
        self.suggestedProducts = products
        
        if !removedIndices.isEmpty {
            view.deleteItems(at: removedIndices)
        }
        if !addedIndices.isEmpty {
            view.insertItems(at: addedIndices)
        }
        if addedIndices.isEmpty && removedIndices.isEmpty {
            view.reloadData()
        }
    }
}
