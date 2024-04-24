//
//  SuggestedCellPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 22.04.2024.
//

import Foundation

protocol SuggestedCellPresenterProtocol: AnyObject {
    func getProduct() -> Product
    func didTapAddButton()
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
    
    /* This function tells the interactor module that the add button has been tapped*/
    func didTapAddButton() {
        interactor.tappedAddButton(product: product)
    }
    
}
