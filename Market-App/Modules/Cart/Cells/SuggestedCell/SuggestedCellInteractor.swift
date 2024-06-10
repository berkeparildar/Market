//
//  SuggestedCellInteractor.swift
//  Market-App
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
    /* This function tells its delegate, in this case the CartViewController that the button has been
    tapped */
    func tappedAddButton(product: Product) {
        cellOwner?.didTapAddButtonFromSuggested(product: product)
    }
}
