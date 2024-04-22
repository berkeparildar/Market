//
//  ProductCellRouter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

final class ProductCellBuilder {
    static func createModule(cellView: ProductCellView, product: Product, navBarOwner: NavigationBarProtocol) {
        let interactor = ProductCellInteractor()
        interactor.navBarDelegate = navBarOwner
        interactor.product = product
        let presenter = ProductCellPresenter(interactor: interactor, view: cellView)
        presenter.product = product
        cellView.presenter = presenter
        interactor.output = presenter
        cellView.configure(product: product)
    }
}