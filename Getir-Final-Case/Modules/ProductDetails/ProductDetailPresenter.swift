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
    func tappedAddButton()
    func countInCart() -> Int
    func tappedRemoveButton()
}

final class ProductDetailPresenter {
    unowned var view: ProductDetailViewControllerProtocol!
    let router: ProductDetailRouterProtocol!
    let interactor: ProductDetailInteractorProtocol!
    
    private var product: Product = Product()
        
    init(view: ProductDetailViewControllerProtocol!, router: ProductDetailRouterProtocol!, interactor: ProductDetailInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    
    func viewDidLoad() {
        view.setupNavigationBar()
        view.setupViews()
        view.setupConstraints()
    }
    
    func getProduct() -> Product {
        return self.product
    }
    
    func tappedAddButton() {
        interactor.productAddedToCart()
    }
    
    func countInCart() -> Int {
        guard let cartStatus = product.cartStatus, let cartInCount = cartStatus.count else { return 0 }
        return cartInCount
    }
    
    func tappedRemoveButton() {
        interactor.productRemovedFromCart()
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
