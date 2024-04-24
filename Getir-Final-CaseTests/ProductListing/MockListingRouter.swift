//
//  RouterTests.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import XCTest
@testable import Getir_Final_Case

final class MockProductListingRouter: ProductListingRouterProtocol {
    var isNavigateCalled = false
    func navigate(_ route: ProductListingRoutes) {
        isNavigateCalled = true
    }
}
