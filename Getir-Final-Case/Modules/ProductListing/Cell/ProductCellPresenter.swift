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
    
    /* These functions tell the interactor module that the add or remove buttons have been tapped. The floating
     stepper is updated each time, and the product's data that the presenter holds is updated*/
    func didTapAddButton() {
        product.isInCart = true
        product.quantityInCart += 1
        interactor.addProductToCart(product: product)
        view.updateFloatingStepper(product: product, animated: true)
    }
    
    func didTapRemoveButton() {
        if product.quantityInCart > 0 {
            product.quantityInCart -= 1
            if product.quantityInCart == .zero {
                product.isInCart = false
            }
            view.updateFloatingStepper(product: product, animated: true)
            interactor.removeProductFromCart(product: product)
        }
    }
}
