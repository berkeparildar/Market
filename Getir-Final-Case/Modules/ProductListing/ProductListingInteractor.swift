//
//  ProductListingInteractor.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

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
    
    /* Tells Cart Service to add the given product to cart, called when the add-remove buttons are tapped from the
     cells */
    func addProductToCart(product: Product) {
        CartService.shared.addProductToCart(product: product)
    }
    
    /* Tells Cart Service to remove the given product to cart, called when the add-remove buttons are tapped from the
     cells */
    func removeProductFromCart(product: Product) {
        CartService.shared.removeProductFromCart(product: product)
    }
    
    /* Function for fetching the products. Note that the products are fetched from the ProductService, after they have
     been converted to the Product models which the module will use. */
    func fetchProducts() {
        ProductService.shared.getProducts { products in
            self.output?.getProductsOutput(products: products)
        }
        ProductService.shared.getSuggestedProducts { suggestedProducts in
            self.output?.getsuggestedProductsOutput(suggestedProducts: suggestedProducts)
        }
    }
    
    /* Functions for updating the cart attributes of the products. Called in the viewWillAppear of the view. */
    func updateCartStatusOfProducts(products: [Product]) {
        let updatedProducts = CartService.shared.updateCartStatusOfProducts(products: products)
        self.output?.updatedProductsOutput(products: updatedProducts)
    }
    
    func updateCartStatusOfSuggestedProducts(products: [Product]) {
        let updatedProducts = CartService.shared.updateCartStatusOfProducts(products: products)
        self.output?.updatedSuggestedProductsOutput(products: updatedProducts)
    }
    
}
