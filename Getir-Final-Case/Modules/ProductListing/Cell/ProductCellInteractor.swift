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
    weak var cellOwnerDelegate: ProductCellOwnerDelegate?
}

extension ProductCellInteractor: ProductCellInteractorProtocol {
    
    func tappedAddButton(product: Product) {
        cellOwnerDelegate?.didTapAddButton(product: product)
    }
    
    func tappedRemoveButton(product: Product) {
        cellOwnerDelegate?.didTapRemoveButton(product: product)
    }
    
}


