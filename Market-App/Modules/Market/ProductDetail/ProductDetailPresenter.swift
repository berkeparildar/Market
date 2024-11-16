//
//  ProductDetailPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

protocol ProductDetailPresenterProtocol {
    func didTapIncrementButton()
    func didTapDecrementButton()
    func setProductData()
    func didTapCartButton()
}

final class ProductDetailPresenter {
    unowned var view: ProductDetailViewProtocol
    private let interactor: ProductDetailInteractorProtocol
    private let router: ProductDetailRouterProtocol
    private var product: Product
    
    init(view: ProductDetailViewProtocol,
         interactor: ProductDetailInteractorProtocol,
         router: ProductDetailRouterProtocol,
         product: Product) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.product = product
    }
}

extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    func didTapCartButton() {
        router.navigate(to: .cart)
    }
    
    func setProductData() {
        view.configure(with: product)
        interactor.getProductCountInCart(product: product)
        interactor.getCartData()
    }
    
    func didTapIncrementButton() {
        interactor.addProductToCart(product: product)
    }
    
    func didTapDecrementButton() {
        interactor.removeProductFromCart(product: product)
    }
    
    func didChangeCart() {
        interactor.getCartData()
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {
    func getCartDataOutput(result: Double) {
        if result == 0.0 {
            view.hideCartButton()
        }
        else {
            view.showCartButton()
        }
            
        view.updateCartButton(price: result)
    }
    
    func getProductCountInCartOutput(result: Int) {
        interactor.getCartData()
        view.updateButtons(quantity: result)
    }
}
