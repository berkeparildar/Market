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
        let presenter = CartCellPresenter(view: cellView, interactor: interactor)
        presenter.product = product
        cellView.presenter = presenter
        cellView.configureWithPresenter()
    }
}
