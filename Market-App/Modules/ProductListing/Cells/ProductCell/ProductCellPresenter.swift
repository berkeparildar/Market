//
//  ProductCellPresenter.swift
//  Market-App
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
        interactor.addProductToCart(product: product)
        view.updateFloatingStepper(product: product, animated: true)
    }
    
    func didTapRemoveButton() {
        interactor.removeProductFromCart(product: product)
        view.updateFloatingStepper(product: product, animated: true)
    }
}
