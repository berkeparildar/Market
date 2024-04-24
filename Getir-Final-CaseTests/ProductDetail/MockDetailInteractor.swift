//
//  InteractorTests.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import XCTest
@testable import Getir_Final_Case

final class MockProductDetailInteractor: ProductDetailInteractorProtocol {
    
    var fetchProductCalled = false
    var addToProductCalled = false
    var removeProductFromCartCalled = false
    
    func fetchProduct() {
        fetchProductCalled = true
    }
    
    func addProductToCart(product: Getir_Final_Case.Product) {
        addToProductCalled = true
    }
    
    func removeProductFromCart(product: Getir_Final_Case.Product) {
        removeProductFromCartCalled = true
    }
}
