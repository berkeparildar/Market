//
//  PresenterTests.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import XCTest
@testable import Getir_Final_Case
@testable import ProductsAPI

final class ProductListingPresenterTests: XCTestCase {
    var presenter: ProductListingPresenter!
    var view: MockProductListingViewController!
    var router: MockProductListingRouter!
    var interactor: MockProductListingInteractor!
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        router = .init()
        presenter = .init(view: view, router: router, interactor: interactor)
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        router = nil
        interactor = nil
        presenter = nil
    }
    
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.setupViewsCalled)
        XCTAssertFalse(view.setupConstraintsCalled)
        XCTAssertFalse(view.showLoadingViewCalled)
        presenter.viewDidLoad()
        XCTAssertTrue(view.setupViewsCalled)
        XCTAssertTrue(view.showLoadingViewCalled)
        XCTAssertTrue(view.setupConstraintsCalled)
    }
    
    func test_viewWillAppear_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.setNavigationBarCalled)
        XCTAssertFalse(view.reloadDataCalled)
        presenter.viewWillAppear()
        XCTAssertTrue(view.setNavigationBarCalled)
        XCTAssertTrue(view.reloadDataCalled)
    }
    
    func test_fetchProducts() {
        XCTAssertFalse(view.showLoadingViewCalled)
        XCTAssertFalse(interactor.fetchProductsCalled)
        presenter.fetchProducts()
        XCTAssertTrue(view.showLoadingViewCalled)
        XCTAssertTrue(interactor.fetchProductsCalled)
        presenter.getProductsOutput(products: NetworkProductResponse.productResponse)
        presenter.getsuggestedProductsOutput(suggestedProducts: NetworkProductResponse.productResponse)
        XCTAssertNotNil(presenter.getProduct(0))
        XCTAssertTrue(view.hideLoadingViewCalled)
    }
    
    func test_cartButton() {
        XCTAssertFalse(router.isNavigateCalled)
        presenter.didTapCartButton()
        XCTAssertTrue(router.isNavigateCalled)
    }
    
    func test_addRemoveButtons() {
        XCTAssertFalse(interactor.addProductToCartCalled)
        XCTAssertFalse(interactor.removeProductFromCartCalled)
        presenter.getProductsOutput(products: NetworkProductResponse.productResponse)
        presenter.didTapAddButtonFromCell(product: presenter.getProduct(0))
        presenter.didTapRemoveButtonFromCell(product: presenter.getProduct(0))
        XCTAssertTrue(interactor.addProductToCartCalled)
        XCTAssertTrue(interactor.removeProductFromCartCalled)
    }
    
    func test_productUpdate() {
        XCTAssertFalse(interactor.updateCartStatusOfProductsCalled)
        XCTAssertFalse(interactor.updateCartStatusOfSuggestedProductsCalled)
        presenter.viewWillAppear()
        XCTAssertTrue(interactor.updateCartStatusOfProductsCalled)
        XCTAssertTrue(interactor.updateCartStatusOfSuggestedProductsCalled)
    }
    
    
}

extension NetworkProductResponse {
    static var productResponse: [Product] {
        let bundle = Bundle(for: ProductListingPresenterTests.self)
        let path = bundle.path(forResource: "Products", ofType: "json")!
        let file = try! String(contentsOfFile: path)
        let data = file.data(using: .utf8)
        let productResponse = try! JSONDecoder().decode([NetworkProductResponse].self, from: data!)
        let products = ProductService.shared.buildProducts(apiProducts: productResponse.first!.results)
        return products
    }
}
