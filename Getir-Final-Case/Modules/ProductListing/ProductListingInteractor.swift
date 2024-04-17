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
    func updateCartRepository(product: Product, quantityIncreased: Bool)
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func fetchProductsOutput(result: [Product])
    func fetchSuggestedProductsOutput(result: [Product])
}

final class ProductListingInteractor {
    var output: ProductListingInteractorOutputProtocol?
}

extension ProductListingInteractor: ProductListingInteractorProtocol {
    
    func fetchProducts() {
        NetworkManager.shared.fetchProducts(fetchCommand: .getProducts) { result in
            switch result {
            case .success(let APIproducts):
                let generatedProducts = ProductBuilder.shared.createProductModels(apiProducts: APIproducts)
                let coreDataProducts = CartRepository.shared.fetchCart()
                let updatedProducts = ProductBuilder.shared.updateCartStatus(generatedProducts: generatedProducts, coreDataProducts: coreDataProducts)
                self.output?.fetchProductsOutput(result: updatedProducts)
            case .failure(_):
                print("Error fetching..")
            }
        }
        
        NetworkManager.shared.fetchProducts(fetchCommand: .getSuggestedProducts) { result in
            switch result {
            case .success(let APIproducts):
                let generatedProducts = ProductBuilder.shared.createProductModels(apiProducts: APIproducts)
                let coreDataProducts = CartRepository.shared.fetchCart()
                let updatedProducts = ProductBuilder.shared.updateCartStatus(generatedProducts: generatedProducts, coreDataProducts: coreDataProducts)
                self.output?.fetchSuggestedProductsOutput(result: updatedProducts)
            case .failure(_):
                print("Error fetching..")
            }
        }
    }
    
    func updateCartRepository(product: Product, quantityIncreased: Bool) {
        CartRepository.shared.updateProduct(product: product, quantityIncreased: quantityIncreased)
    }
}
