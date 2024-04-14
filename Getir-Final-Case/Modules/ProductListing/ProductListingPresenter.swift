//
//  ProductListingPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import Foundation

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfProducts() -> Int
    func numberOfSuggestedProducts() -> Int
    func product(_ index: Int) -> Product
    func suggestedProduct(_ index: Int) -> Product
    func didSelectItemAt(index: Int)
    func tappedCart()
    func tappedProduct(_ index: Int)
}

final class ProductListingPresenter {
    
    unowned var view: ProductListingViewControllerProtocol!
    let router: ProductListingRouterProtocol!
    let interactor: ProductListingInteractorProtocol!
    
    private var products: [Product] = []
    private var suggestedProducts: [Product] = []
    
    init(view: ProductListingViewControllerProtocol!, router: ProductListingRouterProtocol!, interactor: ProductListingInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol {
  
    func viewDidLoad() {
        fetchProducts()
        view.setupView()
        view.setTitle("Ürünler")
        view.setupNavigationBar()
        view.setupVerticalCollectionView()
    }
        
    func product(_ index: Int) -> Product {
        return products[safe: index]!
    }
    
    func suggestedProduct(_ index: Int) -> Product {
        return suggestedProducts[safe: index]!
    }

    func productIndex(id: String) -> Int? {
        return products.firstIndex {
            $0.id == id
        }
    }
    
    func didSelectItemAt(index: Int) {
        print("Tapped product")
        //router.navigate(.detail(product: products[index]))
    }
    
    func numberOfProducts() -> Int {
        return products.count
    }
    
    func numberOfSuggestedProducts() -> Int {
        return suggestedProducts.count
    }
    
    func tappedCart() {
        router.navigate(.cart)
    }
    
    func tappedProduct(_ index: Int) {
        
    }
    
    private func fetchProducts() {
        view.showLoadingView()
        interactor.fetchProducts()
        interactor.fetchSuggestedProducts()
    }
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    func fetchSuggestedProductsOutput(result: [Product]) {
        self.suggestedProducts = result
        view.reloadData()
    }
    
    func fetchProductsOutput(result: [Product]) {
        view.hideLoadingView()
        self.products = result
        view.reloadData()
    }
}
