//
//  ProductListingPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 13.11.2024.
//

protocol ProductListingPresenterProtocol: AnyObject {
    func getProducts()
    func getCategoryCount() -> Int
    func getCategory(at index: Int) -> Category
    func didChangeCart()
}

final class ProductListingPresenter {
    
    unowned var view: ProductListingViewProtocol!
    private let interactor: ProductListingInteractorProtocol!
    private let router: ProductListingRouterProtocol!
    
    private var categories: [Category] = []
    
    init(view: ProductListingViewProtocol!,
         interactor: ProductListingInteractorProtocol!,
         router: ProductListingRouterProtocol!) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol {
    func didChangeCart() {
        interactor.getCartData()
    }
    
    func getProducts() {
        interactor.getProducts()
    }
    
    func getCategoryCount() -> Int {
        return categories.count
    }
    
    func getCategory(at index: Int) -> Category {
        return categories[index]
    }
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    func getCartDataOutput(result: Double) {
        if result == 0.0 {
            view.hideCartButton()
        }
        else {
            view.showCartButton()
        }
            
        view.updateCartButton(price: result)
    }
    
    func getProductsOutput(result: [Category]) {
        self.categories = result
        view.reloadData()
    }
}


