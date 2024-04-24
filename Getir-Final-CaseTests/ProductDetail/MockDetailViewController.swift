//
//  ViewControllerTests.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import XCTest
@testable import Getir_Final_Case

final class MockProductDetailViewController: ProductDetailViewControllerProtocol {
    var setupNavigationBarCalled = false
    var setupViewsCalled = false
    var setupConstraintsCalled = false
    var setProductDataCalled = false
    var configureViewWithCartCountCalled = false
    
    func setupNavigationBar() {
        setupNavigationBarCalled = true
    }
    
    func setupViews() {
        setupViewsCalled = true
    }
    
    func setupConstraints() {
        setupConstraintsCalled = true
    }
    
    func setProductData(_ product: Getir_Final_Case.Product) {
        setProductDataCalled = true
    }
    
    func configureViewWithCartCount() {
        configureViewWithCartCountCalled = true
    }
}
