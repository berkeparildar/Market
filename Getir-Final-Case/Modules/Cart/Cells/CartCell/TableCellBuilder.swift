//
//  TableCellBuilder.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 18.04.2024.
//

import Foundation

final class CartCellBuilder {
    static func createModule(cellView: CartCellView, product: Product, cellOwner: CartCellOwnerDelegate) {
        let interactor = CartCellInteractor()
        interactor.cellOwner = cellOwner
        interactor.product = product
        let presenter = CartCellPresenter(view: cellView, interactor: interactor)
        cellView.presenter = presenter
        interactor.output = presenter
        cellView.configureWithPresenter()
    }
}
