//
//  ProductCellInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductCellInteractorProtocol: AnyObject {
    func tappedAddButton(product: Product)
    func tappedRemoveButton(product: Product)
}

protocol ProductCellInteractorOutputProtocol: AnyObject {
    func getProductOutput(result: Product)
}

final class ProductCellInteractor {
    
    var product: Product?
    weak var output: ProductCellInteractorOutputProtocol?
    weak var navBarDelegate: NavigationBarProtocol?
    weak var cartPresenter: CartPresenterProtocol?
    
}

extension ProductCellInteractor: ProductCellInteractorProtocol {
    
    func tappedAddButton(product: Product) {
        CartService.shared.addProductToCart(product: product)
        cartPresenter?.addButtonTappedFromSuggested(product: product)
        navBarDelegate?.updatePriceInNavigationBar()
    }
    
    func tappedRemoveButton(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
        cartPresenter?.deleteButtonTappedFromSuggested(product: product)
        navBarDelegate?.updatePriceInNavigationBar()
    }
    
}


