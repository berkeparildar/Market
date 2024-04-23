//
//  ProductCellInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductCellInteractorProtocol: AnyObject {
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
}

protocol ProductCellInteractorOutputProtocol: AnyObject {
    func getProductOutput(result: Product)
}

final class ProductCellInteractor {
    
    var product: Product!
    weak var cellOwnerDelegate: ProductCellOwnerDelegate?
    
}

extension ProductCellInteractor: ProductCellInteractorProtocol {
    
    func addProductToCart(product: Product) {
        cellOwnerDelegate?.didTapAddButton(product: product)
    }
    
    func removeProductFromCart(product: Product) {
        cellOwnerDelegate?.didTapRemoveButton(product: product)
    }
    
}


