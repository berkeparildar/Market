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
    
}

extension ProductCellInteractor: ProductCellInteractorProtocol {
    
    func tappedAddButton(product: Product) {
        ProductService.shared.addToCart(product: product)
        navBarDelegate?.updatePriceInNavigationBar()
    }
    
    func tappedRemoveButton(product: Product) {
        ProductService.shared.removeFromCart(product: product)
        navBarDelegate?.updatePriceInNavigationBar()
    }
    
}


