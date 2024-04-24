//
//  MockCartInteractor.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//


import XCTest
@testable import Getir_Final_Case

final class MockCartInteractor: CartInteractorProtocol {
    
    var fetchProductsInCartCalled = false
    
    func fetchProductsInCart() {
        fetchProductsInCartCalled = true
    }
    
    var fetchSuggestedProductsCalled = false
    
    func fetchSuggestedProducts() {
        fetchSuggestedProductsCalled = true
    }
    
    var addProductToCartCalled = false
    
    func addProductToCart(product: Getir_Final_Case.Product) {
        addProductToCartCalled = true
    }
    
    var removeProductFromCartCalled = false
    
    func removeProductFromCart(product: Getir_Final_Case.Product) {
        removeProductFromCartCalled = true
    }
    
    var clearCartCalled = false
    
    func clearCart() {
        clearCartCalled = true
    }
    
}
