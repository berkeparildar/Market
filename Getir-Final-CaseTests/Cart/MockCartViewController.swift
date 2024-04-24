//
//  CartViewControllerTests.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import XCTest
@testable import Getir_Final_Case

final class MockCartViewController: CartViewControllerProtocol {
    
    var setNavigationBarCalled = false
    
    func setupNavigationBar() {
        setNavigationBarCalled = true
    }
    
    var setupViewsCalled = false
    
    func setupViews() {
        setupViewsCalled = true
    }
    
    var setupConstraintsCalled = false
    
    func setupConstraints() {
        setupConstraintsCalled = true
    }
    
    var reloadDataCalled = false
    
    func reloadData() {
        reloadDataCalled = true
    }
    
    var goBackToListingCalled = false
    
    func goBackToListing() {
        goBackToListingCalled = true
    }
    
    var updateTotalPriceCalled = false
    var updatedPrice = 0.0
    
    func updateTotalPrice(price: Double, isAnimated: Bool) {
        updatedPrice = price
        updateTotalPriceCalled = true
    }
    
    var insertCartItemCalled = false
    
    func insertCartItem(at indexPath: IndexPath) {
        insertCartItemCalled = true
    }
    
    var reloadCartItemCalled = false
    
    func reloadCartItem(at indexPath: IndexPath) {
        reloadCartItemCalled = true
    }
    
    var deleteCartItemCalled = false
    
    func deleteCartItem(at indexPath: IndexPath) {
        deleteCartItemCalled = true
    }
    
}
