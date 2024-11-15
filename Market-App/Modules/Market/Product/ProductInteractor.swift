//
//  ProductInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

protocol ProductInteractorProtocol: AnyObject {
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
    func getProductCountInCart(product: Product)
}

protocol ProductInteractorOutputProtocol: AnyObject {
    func getProductCountInCartOutput(result: Int)
    func didChangeCartOutput()
}

final class ProductInteractor {
    var output: ProductInteractorOutputProtocol?
}

extension ProductInteractor: ProductInteractorProtocol {
    func getProductCountInCart(product: Product) {
        output?.getProductCountInCartOutput(
            result: MarketCartService.shared.getProductQuantity(product: product))
    }
    
    func addProductToCart(product: Product) {
        MarketCartService.shared.addProductToCart(product: product)
        output?.getProductCountInCartOutput(
            result: MarketCartService.shared.getProductQuantity(product: product))
        output?.didChangeCartOutput()
    }
    
    func removeProductFromCart(product: Product) {
        MarketCartService.shared.removeProductFromCart(product: product)
        output?.getProductCountInCartOutput(
            result: MarketCartService.shared.getProductQuantity(product: product))
        output?.didChangeCartOutput()
    }
}
