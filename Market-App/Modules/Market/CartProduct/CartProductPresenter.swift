//
//  CartProductPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

protocol CartProductPresenterProtocol: AnyObject {
    func didTapIncrementButton()
    func didTapDecrementButton()
}

final class CartProductPresenter {
    private unowned var view: CartProductViewProtocol!
    private let interactor: CartProductInteractorProtocol
    private let product: MarketCartEntity
    
    var cartUpdateDelegate: CartUpdateDelegate?
    
    init(view: CartProductViewProtocol,
         interactor: CartProductInteractorProtocol,
         product: MarketCartEntity) {
        self.view = view
        self.interactor = interactor
        self.product = product
    }
}

extension CartProductPresenter: CartProductPresenterProtocol {
    func didTapIncrementButton() {
        interactor.addProductToCart(product: product.product)
    }
    
    func didTapDecrementButton() {
        interactor.removeProductFromCart(product: product.product)
    }
}

extension CartProductPresenter: CartProductInteractorOutputProtocol {
    func didChangeCartOutput() {
        cartUpdateDelegate?.updateCart()
    }
}

