//
//  ProductCellRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

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
