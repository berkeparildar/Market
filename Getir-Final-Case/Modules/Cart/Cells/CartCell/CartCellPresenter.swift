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
        return product.inCartCount
    }
    
    func didTapAddButton() {
        product.inCartCount += 1
        view.updateStepper()
        interactor.tappedAddButton(product: self.product)
    }
    
    func didTapRemoveButton() {
        product.inCartCount -= 1
        view.updateStepper()
        interactor.tappedRemoveButton(product: self.product)
    }
    
}
