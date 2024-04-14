//
//  ProductCellInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductCellInteractorProtocol {
    func tappedAddButton(product: Product)
    func tappedRemoveButton(product: Product)
    func fetchImage(url: URL)
}

protocol ProductCellInteractorOutputProtocol {
    func imageData(output: Data)
}

final class ProductCellInteractor {
    var output: ProductCellInteractorOutputProtocol?
}

extension ProductCellInteractor: ProductCellInteractorProtocol {
    func fetchImage(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                print(data)
                self.output?.imageData(output: data)
            }
        }.resume()
    }
    
    func tappedAddButton(product: Product) {
        CartRepository().updateProduct(id: product.id!, add: true)
    }
    
    func tappedRemoveButton(product: Product) {
        CartRepository().updateProduct(id: product.id!, add: false)
    }
}


