//
//  ProductDetailInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

protocol ProductDetailInteractorProtocol {
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
    func getProductCountInCart(product: Product)
    func getCartData()
}

protocol ProductDetailInteractorOutputProtocol: AnyObject {
    func getProductCountInCartOutput(result: Int)
    func getCartDataOutput(result: Double)
}

final class ProductDetailInteractor {
    var output: ProductDetailInteractorOutputProtocol?
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    func getProductCountInCart(product: Product) {
        output?.getProductCountInCartOutput(
            result: MarketCartService.shared.getProductQuantity(product: product))
    }
    
    func addProductToCart(product: Product) {
        MarketCartService.shared.addProductToCart(product: product)
        output?.getProductCountInCartOutput(
            result: MarketCartService.shared.getProductQuantity(product: product))
    }
    
    func removeProductFromCart(product: Product) {
        MarketCartService.shared.removeProductFromCart(product: product)
        output?.getProductCountInCartOutput(
            result: MarketCartService.shared.getProductQuantity(product: product))
    }
    
    func getCartData() {
        let totalPrice = MarketCartService.shared.getTotalPrice()
        output?.getCartDataOutput(result: totalPrice)
    }
}
