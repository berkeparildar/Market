//
//  ProductListingPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.04.2024.
//

import Foundation

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectItemAt(product: Product)
    func didTapCartButton()
    func fetchProducts()
    func didTapAddButtonFromCell(product: Product)
    func didTapRemoveButtonFromCell(product: Product)
}

final class ProductListingPresenter {
    
    unowned var view: ProductListingViewControllerProtocol!
    private let router: ProductListingRouterProtocol!
    private let interactor: ProductListingInteractorProtocol!
    
    var categories: [Category] = []
    
    init(view: ProductListingViewControllerProtocol!, router: ProductListingRouterProtocol!, interactor: ProductListingInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol {
    
    func viewDidLoad() {
        fetchProducts()
        view.setupViews()
        view.setupConstraints()
    }
    
    func viewWillAppear() {
        view.setupNavigationBar()
        view.reloadData()
    }
    
    func didSelectItemAt(product: Product) {
        router.navigate(.detail(product: product))
    }
    
    func didTapCartButton() {
        router.navigate(.cart)
    }
    
    func fetchProducts() {
        view.showLoadingView()
        interactor.fetchProducts()
    }
    
    func didTapAddButtonFromCell(product: Product) {
        interactor.addProductToCart(product: product)
    }
    
    func didTapRemoveButtonFromCell(product: Product) {
        interactor.removeProductFromCart(product: product)
    }
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    func updatedProductsOutput(categories: [Category]) {
        self.categories = categories
    }
    
    func getProductsOutput(categories: [Category]) {
        self.categories = categories
        interactor.updateCartStatusOfProducts(categories: categories)
        view.hideLoadingView()
        view.reloadData()
    }
}

