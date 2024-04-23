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
    func fetchProduct()
}

protocol CartCellInteractorOutputProtocol: AnyObject {
    func getProductOutput(result: Product)
}

final class CartCellInteractor {
    var product: Product?
    weak var output: CartCellInteractorOutputProtocol?
    weak var cellOwner: CartCellOwnerDelegate?
}

extension CartCellInteractor: CartCellInteractorProtocol {
    func tappedAddButton(product: Product) {
        CartService.shared.addProductToCart(product: product)
        cellOwner?.addButtonTapped(product: product)
    }
    
    func tappedRemoveButton(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
        cellOwner?.deleteButtonTapped(product: product)
    }
    
    func fetchProduct() {
        guard let product = self.product else { return }
        self.output?.getProductOutput(result: product)
    }
}
