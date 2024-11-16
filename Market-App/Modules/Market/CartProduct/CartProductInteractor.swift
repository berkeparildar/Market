
//
//  CartProductInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

protocol CartProductInteractorProtocol: AnyObject {
    func addProductToCart(product: Product)
    func removeProductFromCart(product: Product)
}

protocol CartProductInteractorOutputProtocol: AnyObject {
    func didChangeCartOutput()
}

final class CartProductInteractor {
    var output: CartProductInteractorOutputProtocol?
}

extension CartProductInteractor: CartProductInteractorProtocol {
  
    
    func addProductToCart(product: Product) {
        MarketCartService.shared.addProductToCart(product: product)
        output?.didChangeCartOutput()
    }
    
    func removeProductFromCart(product: Product) {
        MarketCartService.shared.removeProductFromCart(product: product)
        output?.didChangeCartOutput()
    }
}
