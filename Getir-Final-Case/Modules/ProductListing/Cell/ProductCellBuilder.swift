//
//  ProductCellRouter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

final class ProductCellBuilder {
    static func createModule(cellView: ProductCellView, product: Product, navBarOwner: NavigationBarProtocol, cartPresenter: CartPresenterProtocol? = nil) {
        let interactor = ProductCellInteractor()
        interactor.navBarDelegate = navBarOwner
        interactor.cartPresenter = cartPresenter
        interactor.product = product
        let presenter = ProductCellPresenter(interactor: interactor, view: cellView)
        presenter.product = product
        cellView.presenter = presenter
        interactor.output = presenter
        cellView.configure(product: product)
    }
}
