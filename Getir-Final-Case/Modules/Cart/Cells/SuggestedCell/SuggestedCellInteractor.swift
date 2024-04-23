//
//  SuggestedCellInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 22.04.2024.
//

import Foundation

protocol SuggestedCellInteractorProtocol: AnyObject {
    func tappedAddButton(product: Product)
}

final class SuggestedCellInteractor {
    
    weak var cellOwner: SuggestedCellOwnerDelegate?
    
}

extension SuggestedCellInteractor: SuggestedCellInteractorProtocol {
    
    func tappedAddButton(product: Product) {
        cellOwner?.didTapAddButtonFromSuggested(product: product)
    }
}
