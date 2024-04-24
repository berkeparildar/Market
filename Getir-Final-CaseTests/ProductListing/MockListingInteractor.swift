//
//  InteractorTests.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import XCTest
@testable import Getir_Final_Case

final class MockProductListingInteractor: ProductListingInteractorProtocol {
    
    var fetchProductsCalled = false
    var updateCartStatusOfProductsCalled = false
    var updateCartStatusOfSuggestedProductsCalled = false
    var addProductToCartCalled = false
    var removeProductFromCartCalled = false
    
    func fetchProducts() {
        fetchProductsCalled = true
    }
    
    func updateCartStatusOfProducts(products: [Product]) {
        updateCartStatusOfProductsCalled = true
    }
    
    func updateCartStatusOfSuggestedProducts(products: [Product]) {
        updateCartStatusOfSuggestedProductsCalled = true
    }
    
    func addProductToCart(product: Product) {
        addProductToCartCalled = true
    }
    
    func removeProductFromCart(product: Product) {
        removeProductFromCartCalled = true
    }
}

