//
//  SuggestedCellInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 22.04.2024.
//

import Foundation

protocol SuggestedCellInteractorProtocol: AnyObject {
    func tappedAddButton(product: Product)
    func tappedRemoveButton(product: Product)
}

protocol SuggestedCellInteractorOutputProtocol: AnyObject {
    func getProductOutput(result: Product)
}

final class SuggestedCellInteractor {
    
    var product: Product?
    weak var output: SuggestedCellInteractorOutputProtocol?
    weak var navBarDelegate: NavigationBarProtocol?
    weak var cartPresenter: CartPresenterProtocol?
    
}

extension SuggestedCellInteractor: SuggestedCellInteractorProtocol {
    
    func tappedAddButton(product: Product) {
        CartService.shared.addProductToCart(product: product)
        cartPresenter?.addButtonTappedFromSuggested(product: product)
        navBarDelegate?.updatePriceInNavigationBar()
    }
    
    func tappedRemoveButton(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
        navBarDelegate?.updatePriceInNavigationBar()
    }
    
}
