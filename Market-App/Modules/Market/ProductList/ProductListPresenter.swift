//
//  ProductListPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

protocol ProductListPresenterProtocol {
    func getProductCount() -> Int
    func getProduct(at index: Int) -> Product
    func didSelectProduct(at index: Int)
    func getCartButtonDelegate() -> CartButtonDelegate?
    func getSelectProductDelegate() -> ProductSelectDelegate?
}

final class ProductListPresenter {
    private var products: [Product]!
    private let view: ProductListViewProtocol
    private let interactor: ProductListInteractorProtocol
    
    var cartButtonDelegate: CartButtonDelegate?
    var productSelectDelegate: ProductSelectDelegate?
    
    init(products: [Product]!, view: ProductListViewProtocol, interactor: ProductListInteractorProtocol) {
        self.products = products
        self.view = view
        self.interactor = interactor
        view.reloadData()
    }
}

extension ProductListPresenter: ProductListPresenterProtocol {
    func getSelectProductDelegate() -> (any ProductSelectDelegate)? {
        return productSelectDelegate
    }
    
    func getCartButtonDelegate() -> (any CartButtonDelegate)? {
        return cartButtonDelegate
    }
    
    func didSelectProduct(at index: Int) {
        let product = getProduct(at: index)
        
    }
    
    func getProductCount() -> Int {
        return products.count
    }
    
    func getProduct(at index: Int) -> Product {
        return products[index]
    }
}

extension ProductListPresenter: ProductListInteractorOutputProtocol {
}
