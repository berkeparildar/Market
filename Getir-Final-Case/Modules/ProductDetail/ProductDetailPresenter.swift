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
    
    func getProductQuantity() -> Int {
        return product.quantityInCart
    }
    
    func didTapAddToCartButton() {
        product.isInCart = true
        product.quantityInCart += 1
        interactor.addProductToCart(product: self.product)
        view.configureViewWithCartCount()
    }
    
    func didTapRemoveFromCartButton() {
        product.quantityInCart -= 1
        if product.quantityInCart == 0 {
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
