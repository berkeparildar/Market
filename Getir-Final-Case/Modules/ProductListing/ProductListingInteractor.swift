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
    func updateCartStatus(products: [Product])
    func updateSuggestedCartStatus(products: [Product])
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func getProductsOutput(products: [Product])
    func getsuggestedProductsOutput(suggestedProducts: [Product])
    func updatedProductsOutput(products: [Product])
    func updatedSuggestedProductsOutput(products: [Product])
}

final class ProductListingInteractor {
    
    var output: ProductListingInteractorOutputProtocol?
}

extension ProductListingInteractor: ProductListingInteractorProtocol {
    
    func fetchProducts() {
        ProductService.shared.getProducts { products in
            self.output?.getProductsOutput(products: products)
        }
        ProductService.shared.getSuggestedProducts { suggestedProducts in
            self.output?.getsuggestedProductsOutput(suggestedProducts: suggestedProducts)
        }
    }
    
    func updateCartStatus(products: [Product]) {
        let updatedProducts = CartService.shared.updateCartStatusOfProducts(products: products)
        self.output?.updatedProductsOutput(products: updatedProducts)
    }
    
    func updateSuggestedCartStatus(products: [Product]) {
        let updatedProducts = CartService.shared.updateCartStatusOfProducts(products: products)
        self.output?.updatedSuggestedProductsOutput(products: updatedProducts)
    }
    
}
