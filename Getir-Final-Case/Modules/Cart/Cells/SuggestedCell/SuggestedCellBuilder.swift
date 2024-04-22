//
//  SuggestedCellBuilder.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 22.04.2024.
//

import Foundation

final class SuggestedCellBuilder {
    static func createModule(cellView: SuggestedCellView, product: Product, navBarOwner: NavigationBarProtocol, cartPresenter: CartPresenterProtocol? = nil) {
        let interactor = SuggestedCellInteractor()
        interactor.navBarDelegate = navBarOwner
        interactor.cartPresenter = cartPresenter
        interactor.product = product
        let presenter = SuggestedCellPresenter(view: cellView, interactor: interactor)
        presenter.product = product
        cellView.presenter = presenter
        interactor.output = presenter
        cellView.configure(product: product)
    }
}

