//
//  CartPresenterTests.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import XCTest
@testable import Getir_Final_Case

final class CartPresenterTests: XCTestCase {
    
    var presenter: CartPresenter!
    var view: MockCartViewController!
    var router: MockCartRouter!
    var interactor: MockCartInteractor!
    
    var mockProduct: Product!
    
    var mockCart: [Product]!
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        router = .init()
        mockProduct = Product(id: "63e642b6d98e4949555fde1d", productName: "Coca-Cola & Fanta & Sprite Trio", productDescription: "Description", productPrice: 0.0, productPriceText: "0.0", isInCart: true, quantityInCart: 1, imageURL: URL(string: "https://market-product-images-cdn.getirapi.com/product/76cec514-00b9-4586-801a-fb5e641fb446.png")!)
        mockCart = [Product]()
        presenter = .init(view: view, router: router, interactor: interactor)
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        router = nil
        interactor = nil
        mockProduct = nil
        mockCart = nil
        presenter = nil
    }
    
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.setupViewsCalled)
        XCTAssertFalse(view.setupConstraintsCalled)
        presenter.viewDidLoad()
        XCTAssertTrue(view.setupViewsCalled)
        XCTAssertTrue(view.setupConstraintsCalled)
    }
    
    func test_viewWillAppear_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.setNavigationBarCalled)
        XCTAssertFalse(view.updateTotalPriceCalled)
        presenter.viewWillAppear()
        XCTAssertTrue(view.setNavigationBarCalled)
        XCTAssertTrue(view.updateTotalPriceCalled)
    }
    
    func test_fetchProduct_InvokesRequiredInteractorMethods() {
        XCTAssertFalse(interactor.fetchProductsInCartCalled)
        XCTAssertFalse(interactor.fetchSuggestedProductsCalled)
        presenter.viewWillAppear()
        XCTAssertTrue(interactor.fetchProductsInCartCalled)
        XCTAssertTrue(interactor.fetchSuggestedProductsCalled)
    }
    
    func test_addButton_InvokesRequiredMethods() {
        XCTAssertEqual(mockProduct.quantityInCart, 1)
        XCTAssertTrue(mockProduct.isInCart)
        XCTAssertEqual(view.updatedPrice, 0)
        XCTAssertFalse(interactor.addProductToCartCalled)
        mockCart.append(mockProduct)
        presenter.fetchProductsInCartOutput(result: mockCart)
        presenter.addButtonTappedFromCart(product: mockProduct)
        XCTAssertEqual(presenter.getProductInCart(0).quantityInCart, 2)
        XCTAssertTrue(presenter.getProductInCart(0).isInCart)
        XCTAssertEqual(view.updatedPrice, presenter.getProductInCart(0).productPrice)
        XCTAssertTrue(view.updateTotalPriceCalled)
        XCTAssertTrue(interactor.addProductToCartCalled)
    }
    
    func test_removeButton_InvokesRequiredMethods() {
        XCTAssertEqual(mockProduct.quantityInCart, 1)
        XCTAssertTrue(mockProduct.isInCart)
        XCTAssertFalse(interactor.removeProductFromCartCalled)
        mockCart.append(mockProduct)
        presenter.fetchProductsInCartOutput(result: mockCart)
        presenter.removeButtonTappedFromCart(product: mockProduct)
        XCTAssertTrue(view.updateTotalPriceCalled)
        XCTAssertTrue(interactor.removeProductFromCartCalled)
    }
}
