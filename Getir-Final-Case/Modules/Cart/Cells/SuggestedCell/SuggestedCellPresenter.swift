//
//  SuggestedCellPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 22.04.2024.
//

import Foundation

protocol SuggestedCellPresenterProtocol: AnyObject {
    func getProduct() -> Product
    func tappedAdd()
}
        
final class SuggestedCellPresenter {
    
    var product: Product!
    unowned var view: SuggestedCellViewProtocol!
    let interactor: SuggestedCellInteractorProtocol!
    
    init(view: SuggestedCellViewProtocol!, interactor: SuggestedCellInteractorProtocol!) {
        self.view = view
        self.interactor = interactor
    }
    
}

extension SuggestedCellPresenter: SuggestedCellPresenterProtocol {
    
    func getProduct() -> Product {
        return self.product
    }
    
    func tappedAdd() {
        product.isInCart = true
        product.inCartCount += 1
        interactor.tappedAddButton(product: product)
    }
    
}

extension SuggestedCellPresenter: SuggestedCellInteractorOutputProtocol {
    
    func getProductOutput(result: Product) {
        self.product = result
    }
    
    
    
}
