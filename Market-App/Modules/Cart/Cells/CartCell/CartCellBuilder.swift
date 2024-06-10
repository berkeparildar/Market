//
//  TableCellBuilder.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.04.2024.
//

import Foundation

// Builder class for the CartCell, the product data is directly passed to the presenter of the cell.
// The configure method of the cell is also being called here, not in presenter.
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
