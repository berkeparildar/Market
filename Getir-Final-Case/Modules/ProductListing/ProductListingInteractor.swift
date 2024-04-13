//
//  ProductListingInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import RxSwift
import Foundation

protocol ProductListingInteractorProtocol: AnyObject {
    func fetchProducts()
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func fetchProductsOutput(result: [Product])
}

final class ProductListingInteractor {
    var output: ProductListingInteractorOutputProtocol?
}

extension ProductListingInteractor: ProductListingInteractorProtocol {
    func fetchProducts() {
        NetworkManager.shared.provider.request(.getProducts) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let data = moyaResponse.data
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([ProductAPIResponse].self, from: data)
                    guard let validResponse = decodedData.first else { return }
                    self.output?.fetchProductsOutput(result: validResponse.products ?? [Product()])
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
