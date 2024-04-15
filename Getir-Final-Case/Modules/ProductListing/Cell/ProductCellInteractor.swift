//
//  ProductCellInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductCellInteractorProtocol: AnyObject {
    func tappedAddButton(product: Product)
    func tappedRemoveButton(product: Product)
    func fetchImage(url: URL)
}

protocol ProductCellInteractorOutputProtocol: AnyObject {
    func imageData(output: Data)
}

protocol UpdateNavigationBarProtocol: AnyObject {
    func updateNavigationBar()
}

final class ProductCellInteractor {
    weak var output: ProductCellInteractorOutputProtocol?
    weak var navBarNotifier: UpdateNavigationBarProtocol?
}

extension ProductCellInteractor: ProductCellInteractorProtocol {
    func fetchImage(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.output?.imageData(output: data)
            }
        }.resume()
    }
    
    func tappedAddButton(product: Product) {
        CartRepository.shared.updateProduct(id: product.id!, price: product.price!, add: true)
        navBarNotifier?.updateNavigationBar()
    }
    
    func tappedRemoveButton(product: Product) {
        CartRepository.shared.updateProduct(id: product.id!, price: product.price!, add: false)
        navBarNotifier?.updateNavigationBar()
    }
}


