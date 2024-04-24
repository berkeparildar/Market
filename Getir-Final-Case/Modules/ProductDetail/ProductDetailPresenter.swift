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
    
    /*Returns the current amount of that product in cart, used in configureing the add to cart button or steppers.*/
    func getProductQuantity() -> Int {
        return product.quantityInCart
    }
    
    /* The add and remove functions that are called when the user taps on one of the buttons in the bottom. This
     function updates the quantityInCart and isInCart attributes of the product, and tells interactor to update the
     cart using CartService. Tell's view to update accordingly */
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
    
    /* Function for handling the tap on the cart button, navigates to the Cart View */
    func didTapCartButton() {
        router.navigate(.cart)
    }
    
}

extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {
 
    func product(product: Product) {
        self.product = product
    }
    
}
