//
//  ProductDetailPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func getProduct() -> Product
    func getProductQuantity() -> Int
    func didTapAddToCartButton()
    func didTapRemoveFromCartButton()
    func didTapCartButton()
}

final class ProductDetailPresenter {
    
    unowned var view: ProductDetailViewControllerProtocol!
    private let router: ProductDetailRouterProtocol!
    private let interactor: ProductDetailInteractorProtocol!
    
    private var product: Product!
        
    init(view: ProductDetailViewControllerProtocol!, router: ProductDetailRouterProtocol!, interactor: ProductDetailInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    
    func viewDidLoad() {
        interactor.fetchProduct()
        view.setupViews()
        view.setupConstraints()
    }
    
    func viewWillAppear() {
        view.setupNavigationBar()
        view.setProductData(self.product)
        view.configureViewWithCartCount()
    }
    
    func getProduct() -> Product {
        return self.product
    }
    
    func getProductQuantity() -> Int {
        return product.inCartCount
    }
    
    func didTapAddToCartButton() {
        product.isInCart = true
        product.inCartCount += 1
        interactor.addProductToCart(product: self.product)
        view.configureViewWithCartCount()
    }
    
    func didTapRemoveFromCartButton() {
        product.inCartCount -= 1
        if product.inCartCount == 0 {
            product.isInCart = false
        }
        interactor.removeProductFromCart(product: self.product)
        view.configureViewWithCartCount()
    }
    
    func didTapCartButton() {
        router.navigate(.cart)
    }
    
}

extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {
 
    func product(product: Product) {
        self.product = product
    }
    
}
