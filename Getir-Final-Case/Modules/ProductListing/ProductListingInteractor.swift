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
    func fetchProductInCart()
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func fetchProductsOutput(result: [Product])
    func fetchSuggestedProductsOutput(result: [Product])
    func fetchProductsInCartOutput(result: [Product])
}

final class ProductListingInteractor {

    var output: ProductListingInteractorOutputProtocol?
}

extension ProductListingInteractor: ProductListingInteractorProtocol {
    
    func fetchProducts() {
        ProductService.shared.fetchProducts { products in
            self.output?.fetchProductsOutput(result: products)
        }
        ProductService.shared.fetchSuggestedProducts { suggestedProducts in
            self.output?.fetchSuggestedProductsOutput(result: suggestedProducts)
        }
    }
    
    func fetchProductInCart() {
        let cartProducts = ProductService.shared.fetchCartProducts()
        self.output?.fetchProductsInCartOutput(result: cartProducts)
    }
    
}
