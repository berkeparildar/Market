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
    func updateCartRepository(with id: String, add: Bool)
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func fetchProductsOutput(result: [Product])
}

final class ProductListingInteractor {
    var output: ProductListingInteractorOutputProtocol?
}

extension ProductListingInteractor: ProductListingInteractorProtocol {
  
    func fetchProducts() {
        let cartRepository = CartRepository()
        NetworkManager.shared.provider.request(.getProducts) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    var updatedProducts  = [Product]()
                    let data = moyaResponse.data
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([ProductAPIResponse].self, from: data)
                    guard let validResponse = decodedData.first else { return }
                    guard let cartItems = cartRepository.fetchCart() else { return }
                    guard let products = validResponse.products else { return }
                    for product in products {
                        var updatedProduct = product
                        if !cartItems.isEmpty {
                            for cartItem in cartItems {
                                if updatedProduct.id == cartItem.id {
                                    updatedProduct.cartStatus = cartItem
                                }
                            }
                        }
                        else {
                            updatedProduct.cartStatus = CartProduct(id: updatedProduct.id, count: 0, isInCart: false)
                        }
                        updatedProducts.append(updatedProduct)
                    }
                    self.output?.fetchProductsOutput(result: updatedProducts)
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func updateCartRepository(with id: String, add: Bool) {
        CartRepository().updateProduct(id: id, add: add)
    }
}
