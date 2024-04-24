//
//  MockCartRouter.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import Foundation

import XCTest
@testable import Getir_Final_Case

final class MockCartRouter: CartRouterProtocol {
    var navigateCalled = false
    func navigate(_ route: CartRoutes) {
        navigateCalled = true
    }
}
