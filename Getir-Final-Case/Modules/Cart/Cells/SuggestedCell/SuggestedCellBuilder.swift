//
//  SuggestedCellBuilder.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 22.04.2024.
//

import Foundation

final class SuggestedCellBuilder {
    static func createModule(cellView: SuggestedCellView, product: Product, cellOwner: SuggestedCellOwnerDelegate? = nil) {
        let interactor = SuggestedCellInteractor()
        interactor.cellOwner = cellOwner
        let presenter = SuggestedCellPresenter(view: cellView, interactor: interactor)
        presenter.product = product
        cellView.presenter = presenter
        cellView.configure(product: product)
    }
}

