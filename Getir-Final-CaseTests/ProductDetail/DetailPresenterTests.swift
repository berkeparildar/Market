//
//  PresenterTests.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import XCTest
@testable import Getir_Final_Case

final class ProductDetailPresenterTests: XCTestCase {
    var presenter: ProductDetailPresenter!
    var view: MockProductDetailViewController!
    var router: MockProductDetailRouter!
    var interactor: MockProductDetailInteractor!
    var mockProduct: Product!
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        router = .init()
        presenter = .init(view: view, router: router, interactor: interactor)
        mockProduct = Product(id: "63e642b6d98e4949555fde1d", productName: "Coca-Cola & Fanta & Sprite Trio", productDescription: "Description", productPrice: 0.0, productPriceText: "0.0", isInCart: false, quantityInCart: 0, imageURL: URL(string: "https://market-product-images-cdn.getirapi.com/product/76cec514-00b9-4586-801a-fb5e641fb446.png")!)
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        router = nil
        interactor = nil
        presenter = nil
        mockProduct = nil
    }
    
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.setupViewsCalled)
        XCTAssertFalse(view.setupConstraintsCalled)
        presenter.viewDidLoad()
        XCTAssertTrue(view.setupViewsCalled)
        XCTAssertTrue(view.setupConstraintsCalled)
    }
    
    func test_viewWillAppear_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.setupNavigationBarCalled)
        XCTAssertFalse(view.setProductDataCalled)
        XCTAssertFalse(view.configureViewWithCartCountCalled)
        presenter.product(product: mockProduct)
        presenter.viewWillAppear()
        XCTAssertNotNil(presenter.getProduct())
        XCTAssertTrue(view.setupNavigationBarCalled)
        XCTAssertTrue(view.setProductDataCalled)
        XCTAssertTrue(view.configureViewWithCartCountCalled)
    }
    
    func test_fetchProduct() {
        XCTAssertFalse(interactor.fetchProductCalled)
        interactor.fetchProduct()
        XCTAssertTrue(interactor.fetchProductCalled)
    }
    
    func test_cartButton() {
        XCTAssertFalse(router.isNavigateCalled)
        presenter.didTapCartButton()
        XCTAssertTrue(router.isNavigateCalled)
    }
    
    func test_addRemoveButtons() {
        XCTAssertFalse(mockProduct.isInCart)
        XCTAssertEqual(mockProduct.quantityInCart, 0)
        presenter.product(product: mockProduct)
        XCTAssertFalse(interactor.addToProductCalled)
        XCTAssertFalse(interactor.removeProductFromCartCalled)
        presenter.didTapAddToCartButton()
        XCTAssertEqual(presenter.getProduct().quantityInCart, 1)
        XCTAssertTrue(interactor.addToProductCalled)
        presenter.didTapRemoveFromCartButton()
        XCTAssertTrue(interactor.removeProductFromCartCalled)
        XCTAssertEqual(presenter.getProduct().quantityInCart, 0)
        XCTAssertFalse(presenter.getProduct().isInCart)
    }
    
    func test_productQuantity() {
        XCTAssertEqual(mockProduct.quantityInCart, 0)
        presenter.product(product: mockProduct)
        XCTAssertEqual(presenter.getProductQuantity(), 0)
    }
}
