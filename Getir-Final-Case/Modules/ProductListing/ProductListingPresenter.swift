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
    func didSelectItemAt(section: Int, index: Int)
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
        view.setupCollectionView()
        view.setupViews()
    }
    
    func viewWillAppear() {
        view.setTitle()
        view.reloadData()
    }
    
    func product(_ index: Int) -> Product {
        return products[safe: index]!
    }
    
    func suggestedProduct(_ index: Int) -> Product {
        return suggestedProducts[safe: index]!
    }
    
    func didSelectItemAt(section: Int, index: Int) {
        if section == 0 {
            router.navigate(.detail(product: suggestedProducts[index]))
        }
        else {
            router.navigate(.detail(product: products[index]))
        }
    }
    
    func numberOfProducts() -> Int {
        return products.count
    }
    
    func numberOfSuggestedProducts() -> Int {
        return suggestedProducts.count
    }

    private func fetchProducts() {
        view.showLoadingView()
        interactor.fetchProducts()
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
