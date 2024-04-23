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
    func updateCartStatusOfProducts(products: [Product])
    func updateCartStatusOfSuggestedProducts(products: [Product])
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
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
    
    func addProductToCart(product: Product) {
        CartService.shared.addProductToCart(product: product)
    }
    
    func removeProductFromCart(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
    }
    
    func fetchProducts() {
        ProductService.shared.getProducts { products in
            self.output?.getProductsOutput(products: products)
        }
        ProductService.shared.getSuggestedProducts { suggestedProducts in
            self.output?.getsuggestedProductsOutput(suggestedProducts: suggestedProducts)
        }
    }
    
    func updateCartStatusOfProducts(products: [Product]) {
        let updatedProducts = CartService.shared.updateCartStatusOfProducts(products: products)
        self.output?.updatedProductsOutput(products: updatedProducts)
    }
    
    func updateCartStatusOfSuggestedProducts(products: [Product]) {
        let updatedProducts = CartService.shared.updateCartStatusOfProducts(products: products)
        self.output?.updatedSuggestedProductsOutput(products: updatedProducts)
    }
    
}
