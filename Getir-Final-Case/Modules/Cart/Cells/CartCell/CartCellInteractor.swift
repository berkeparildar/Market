//
//  TableCellInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 18.04.2024.
//

import Foundation

protocol CartCellInteractorProtocol: AnyObject {
    func tappedAddButton(product: Product)
    func tappedRemoveButton(product: Product)
}

final class CartCellInteractor {
    weak var cellOwner: CartCellOwnerDelegate?
}

extension CartCellInteractor: CartCellInteractorProtocol {
    func tappedAddButton(product: Product) {
        cellOwner?.didTapAddButtonFromCart(product: product)
    }
    
    func tappedRemoveButton(product: Product) {
        cellOwner?.didTapRemoveButtonFromCart(product: product)
    }

}
