//
//  ProductListInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

protocol ProductListInteractorProtocol: AnyObject {
}

protocol ProductListInteractorOutputProtocol: AnyObject {
}

final class ProductListInteractor {
    var output: ProductListInteractorOutputProtocol?
}

extension ProductListInteractor: ProductListInteractorProtocol {
}
