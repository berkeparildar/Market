//
//  ProductCellRouter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

// Builder class for the ProductCell, the product data is directly passed to the presenter of the cell.
// The configure method of the cell is also being called here, not in presenter.
final class ProductCellBuilder {
    static func createModule(cellView: ProductCellView, product: Product, cellOwner: ProductCellOwnerDelegate) {
        let interactor = ProductCellInteractor()
        interactor.cellOwnerDelegate = cellOwner
        let presenter = ProductCellPresenter(interactor: interactor, view: cellView)
        presenter.product = product
        cellView.presenter = presenter
        cellView.configure(product: product)
    }
}
