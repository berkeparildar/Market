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
    func didTapCartButton()
}

protocol ProductCellDelegate: AnyObject {
    func didAddProductToCart(product: Product)
    func didRemoveProductFromCart(product: Product)
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
    
    func didTapCartButton() {
        router.navigate(.cart(suggestedProducts: self.suggestedProducts))
    }
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        view.setupNavigationBar()
        view.setTitle()
        if products.isEmpty {
            fetchProducts()
        }
        else {
            interactor.fetchProductInCart()
        }
        view.setupViews()
        view.setupConstraints()
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
    
    func fetchProductsInCartOutput(result: [Product]) {
        let productsInCart = result
        self.products = ProductService.shared.updateFetchedProducts(currentProducts: self.products, coreDataProducts: productsInCart)
        self.suggestedProducts = ProductService.shared.updateFetchedProducts(currentProducts: self.suggestedProducts, coreDataProducts: productsInCart)
        view.reloadData()
    }
    
    func fetchSuggestedProductsOutput(result: [Product]) {
        self.suggestedProducts = result
        view.reloadData()
    }
    
    func fetchProductsOutput(result: [Product]) {
        self.products = result
        view.reloadData()
        view.hideLoadingView()
    }
}

