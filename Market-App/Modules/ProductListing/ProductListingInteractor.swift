//
//  ProductListingInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.04.2024.
//

import Foundation

protocol ProductListingInteractorProtocol: AnyObject {
    func fetchProducts()
    func updateCartStatusOfProducts(categories: [Category])
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func getProductsOutput(categories: [Category])
    func updatedProductsOutput(categories: [Category])
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
        /*
        ProductService.shared.getProducts { categories in
            self.output?.getProductsOutput(categories: categories)
        }*/
    }
    
    func updateCartStatusOfProducts(categories: [Category]) {
        CartService.shared.updateCartStatusOfProducts(categories: categories)
        self.output?.updatedProductsOutput(categories: categories)
    }
}
