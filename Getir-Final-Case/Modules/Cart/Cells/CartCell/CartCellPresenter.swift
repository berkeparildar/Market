//
//  TableCellPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 18.04.2024.
//

import Foundation

protocol CartCellPresenterProtocol {
    func getProduct() -> Product
    func didTapAddButton()
    func didTapRemoveButton()
    func getProductCount() -> Int
}

final class CartCellPresenter {
    var product: Product!
    unowned var view: CartCellViewProtocol!
    let interactor: CartCellInteractorProtocol!
    
    init(view: CartCellViewProtocol!, interactor: CartCellInteractorProtocol!) {
        self.view = view
        self.interactor = interactor
    }
}

extension CartCellPresenter: CartCellPresenterProtocol {
    
    func getProduct() -> Product {
        return self.product
    }
    
    func getProductCount() -> Int {
        return product.quantityInCart
    }
    
    /* These functions tell the interactor module that the add or remove buttons have been tapped. The
     stepper is updated each time, and the product's data that the presenter holds is updated*/
    func didTapAddButton() {
        product.quantityInCart += 1
        view.updateStepper()
        interactor.tappedAddButton(product: self.product)
    }
    
    func didTapRemoveButton() {
        product.quantityInCart -= 1
        view.updateStepper()
        interactor.tappedRemoveButton(product: self.product)
    }
    
}
