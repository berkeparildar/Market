//
//  ProductCellPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductCellPresenterProtocol: AnyObject {
    func didTapAddButton()
    func didTapRemoveButton()
}

final class ProductCellPresenter {
    
    var product: Product!
    unowned var view: ProductCellViewProtocol!
    private let interactor: ProductCellInteractorProtocol!
    
    init(interactor: ProductCellInteractorProtocol!, view: ProductCellViewProtocol!) {
        self.interactor = interactor
        self.view = view
    }
    
}

extension ProductCellPresenter: ProductCellPresenterProtocol {
    
    func didTapAddButton() {
        product.isInCart = true
        product.inCartCount += 1
        interactor.addProductToCart(product: product)
        view.updateFloatingBar(product: product, animated: true)
    }
    
    func didTapRemoveButton() {
        if product.inCartCount > 0 {
            if product.inCartCount == 1 {
                product.inCartCount = 0
                product.isInCart = false
            }
            else {
                product.inCartCount -= 1
            }
            view.updateFloatingBar(product: product, animated: true)
            interactor.removeProductFromCart(product: product)
        }
    }
}
