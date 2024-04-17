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
}



final class ProductCellInteractor {
    weak var output: ProductCellInteractorOutputProtocol?
    weak var navBarNotifier: UpdateNavigationBarProtocol?
}

extension ProductCellInteractor: ProductCellInteractorProtocol {

    func tappedAddButton(product: Product) {
        CartRepository.shared.updateProduct(product: product, quantityIncreased: true)
        navBarNotifier?.updateNavigationBar()
    }
    
    func tappedRemoveButton(product: Product) {
        CartRepository.shared.updateProduct(product: product, quantityIncreased: false)
        navBarNotifier?.updateNavigationBar()
    }
}


