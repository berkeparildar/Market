//
//  ProductPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

protocol ProductPresenterProtocol: AnyObject {
    func didTapIncrementButton()
    func didTapDecrementButton()
    func getProductCount()
}

final class ProductPresenter {
    private let interactor: ProductInteractorProtocol
    private let view: ProductViewProtocol
    private let product: Product!
    
    var cartButtonDelegate: CartButtonDelegate?

    init(interactor: ProductInteractorProtocol, view: ProductViewProtocol, product: Product!) {
        self.interactor = interactor
        self.view = view
        self.product = product
        interactor.getProductCountInCart(product: product)
    }
}

extension ProductPresenter: ProductPresenterProtocol {
    func getProductCount() {
        interactor.getProductCountInCart(product: product)
    }
    
    func didTapIncrementButton() {
        interactor.addProductToCart(product: product)
    }
    
    func didTapDecrementButton() {
        interactor.removeProductFromCart(product: product)

    }
}

extension ProductPresenter: ProductInteractorOutputProtocol {
    func didChangeCartOutput() {
        cartButtonDelegate?.didChangeCart()
    }
    
    func getProductCountInCartOutput(result: Int) {
        view.updateProductQuantity(quantity: result)
    }
}
