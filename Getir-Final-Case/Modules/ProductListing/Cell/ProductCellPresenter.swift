//
//  ProductCellPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductCellPresenterProtocol {
    func getProduct() -> Product
    func productCount() -> Int
    func expanded() -> Bool
    func tappedAdd()
    func tappedRemove()
}

final class ProductCellPresenter {
    var product: Product
    
    unowned var view: ProductCellViewProtocol!
    let interactor: ProductCellInteractorProtocol!
    
    init(interactor: ProductCellInteractorProtocol!, view: ProductCellViewProtocol!, product: Product) {
        self.interactor = interactor
        self.view = view
        self.product = product
    }
}

extension ProductCellPresenter: ProductCellPresenterProtocol {
    func getProduct() -> Product {
        return self.product
    }
    
    func productCount() -> Int {
        return product.inCartCount
    }
    
    func expanded() -> Bool {
        return product.isInCart
    }
    
    func tappedAdd() {
        product.isInCart = true
        product.inCartCount += 1
        view.updateAddSection(isExpanded: true, animated: true)
        view.updateQuantityLabel()
        view.setDeleteButtonImage()
        interactor.tappedAddButton(product: product)
    }
    
    func tappedRemove() {
        if product.inCartCount == 1 {
            product.inCartCount = 0
            product.isInCart = false
            view.updateAddSection(isExpanded: false, animated: true)
        }
        else {
            product.inCartCount -= 1
            if product.inCartCount == 1 {
                view.setDeleteButtonImage()
            }
        }
        view.updateQuantityLabel()
        interactor.tappedRemoveButton(product: product)
    }
}

extension ProductCellPresenter: ProductCellInteractorOutputProtocol {
}
