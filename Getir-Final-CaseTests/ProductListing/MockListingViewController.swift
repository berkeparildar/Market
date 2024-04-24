//
//  ViewControllerTests.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import XCTest
@testable import Getir_Final_Case

final class MockProductListingViewController: ProductListingViewControllerProtocol {
    
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
    
    var showLoadingViewCalled = false
    
    func showLoadingView() {
        showLoadingViewCalled = true
    }
    
    var hideLoadingViewCalled = false
    
    func hideLoadingView() {
        hideLoadingViewCalled = true
    }
    
}
