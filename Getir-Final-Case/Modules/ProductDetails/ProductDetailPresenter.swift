//
//  ProductDetailPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func fetchProduct()
    func getProduct() -> Product
    func tappedAddToCartButton()
    func countInCart() -> Int
    func tappedRemoveButton()
}

final class ProductDetailPresenter {
    unowned var view: ProductDetailViewControllerProtocol!
    let router: ProductDetailRouterProtocol!
    let interactor: ProductDetailInteractorProtocol!
    
    private var product: Product!
        
    init(view: ProductDetailViewControllerProtocol!, router: ProductDetailRouterProtocol!, interactor: ProductDetailInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    
    func viewDidLoad() {
        interactor.getProduct()
        view.setupNavigationBar()
        view.setupViews()
        view.setupConstraints()
        view.setProductData(self.product)
        view.configureViewWithCartCount()
    }
    
    func getProduct() -> Product {
        return self.product
    }
    
    func tappedAddToCartButton() {
        product.isInCart = true
        product.inCartCount += 1
        interactor.productAddedToCart()
        view.configureViewWithCartCount()
    }
    
    func countInCart() -> Int {
        return product.inCartCount
    }
    
    func tappedRemoveButton() {
        product.inCartCount -= 1
        if product.inCartCount == 0 {
            product.isInCart = false
        }
        interactor.productRemovedFromCart()
        view.configureViewWithCartCount()
    }
    
    func fetchProduct() {
        interactor.getProduct()
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {
 
    func product(product: Product) {
        self.product = product
    }
}
