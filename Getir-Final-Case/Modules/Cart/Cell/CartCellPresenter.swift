//
//  TableCellPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 18.04.2024.
//

import Foundation

protocol CartCellPresenterProtocol {
    func getProduct() -> Product
    func tappedQuantityIncreaseButton()
    func tappedQuantityDecreaseButton()
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
        interactor.fetchProduct()
        return self.product
    }
    
    func getProductCount() -> Int {
        return product.inCartCount
    }
    
    func tappedQuantityIncreaseButton() {
        product.inCartCount += 1
        view.updateQuantityLabel()
        view.setDeleteButtonImage()
        interactor.tappedAddButton(product: self.product)
    }
    
    func tappedQuantityDecreaseButton() {
        product.inCartCount -= 1
        view.updateQuantityLabel()
        view.setDeleteButtonImage()
        interactor.tappedRemoveButton(product: self.product)
    }
}

extension CartCellPresenter: CartCellInteractorOutputProtocol {
    func getProductOutput(result: Product) {
        self.product = result
    }
}
