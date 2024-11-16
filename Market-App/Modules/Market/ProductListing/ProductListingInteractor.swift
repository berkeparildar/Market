//
//  ProductListingInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 13.11.2024.
//

protocol ProductListingInteractorProtocol: AnyObject {
    func getProducts()
    func getCartData()
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func getProductsOutput(result: [Category])
    func getCartDataOutput(result: Double)
}

final class ProductListingInteractor {
    var output: ProductListingInteractorOutputProtocol?
}

extension ProductListingInteractor: ProductListingInteractorProtocol {
    func getCartData() {
        let totalPrice = MarketCartService.shared.getTotalPrice()
        output?.getCartDataOutput(result: totalPrice)
    }
    
    func getProducts() {
        ProductService.shared.setProducts { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching products: \(error)")
            }
            let products = ProductService.shared.getProducts()
            output?.getProductsOutput(result: products)
        }
    }
}
