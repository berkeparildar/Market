//
//  ProductCellPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductCellPresenterProtocol: AnyObject {
    func getProduct() -> Product
    func tappedAdd()
    func tappedRemove()
}

final class ProductCellPresenter {
    
    var product: Product!
    unowned var view: ProductCellViewProtocol!
    let interactor: ProductCellInteractorProtocol!
    
    init(interactor: ProductCellInteractorProtocol!, view: ProductCellViewProtocol!) {
        self.interactor = interactor
        self.view = view
    }
    
}

extension ProductCellPresenter: ProductCellPresenterProtocol {
    
    func getProduct() -> Product {
        return self.product
    }
    
    func tappedAdd() {
        product.isInCart = true
        product.inCartCount += 1
        interactor.tappedAddButton(product: product)
        view.updateFloatingBar(product: product, animated: true)
    }
    
    func tappedRemove() {
        if product.inCartCount == 1 {
            product.inCartCount = 0
            product.isInCart = false
        }
        else {
            product.inCartCount -= 1
        }
        view.updateFloatingBar(product: product, animated: true)
        interactor.tappedRemoveButton(product: product)
    }
}

extension ProductCellPresenter: ProductCellInteractorOutputProtocol {
    func getProductOutput(result: Product) {
        self.product = result
    }
}
