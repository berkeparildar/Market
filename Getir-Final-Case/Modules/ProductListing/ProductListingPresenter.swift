//
//  ProductListingPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import Foundation

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func getProduct(_ index: Int) -> Product
    func getProductCount() -> Int
    func getSuggestedProduct(_ index: Int) -> Product
    func getSuggestedProductCount() -> Int
    func didSelectItemAt(indexPath: IndexPath)
    func didTapCartButton()
    func didTapAddButtonFromCell(product: Product)
    func didTapRemoveButtonFromCell(product: Product)
}

final class ProductListingPresenter {
    
    unowned var view: ProductListingViewControllerProtocol!
    private let router: ProductListingRouterProtocol!
    private let interactor: ProductListingInteractorProtocol!
    
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
        view.setupViews()
        view.setupConstraints()
    }
    
    func viewWillAppear() {
        view.setupNavigationBar()
        interactor.updateCartStatusOfProducts(products: products)
        interactor.updateCartStatusOfSuggestedProducts(products: suggestedProducts)
        view.reloadData()
    }
    
    func getProduct(_ index: Int) -> Product {
        return products[safe: index]!
    }
    
    func getSuggestedProduct(_ index: Int) -> Product {
        return suggestedProducts[safe: index]!
    }
    
    func getProductCount() -> Int {
        return products.count
    }
    
    func getSuggestedProductCount() -> Int {
        return suggestedProducts.count
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        if indexPath.section == 0 {
            router.navigate(.detail(product: suggestedProducts[indexPath.item]))
        }
        else {
            router.navigate(.detail(product: products[indexPath.item]))
        }
    }
    
    func didTapCartButton() {
        router.navigate(.cart(suggestedProducts: self.suggestedProducts))
    }

    private func fetchProducts() {
        view.showLoadingView()
        interactor.fetchProducts()
    }
    
    func didTapAddButtonFromCell(product: Product) {
        if let match = products.firstIndex(where: { $0.id == product.id }) {
            if products[match].inCartCount == 0 {
                products[match].isInCart = true
            }
            products[match].inCartCount += 1
        }
        if let suggestedMatch = suggestedProducts.firstIndex(where: { $0.id == product.id}) {
            if suggestedProducts[suggestedMatch].inCartCount == 0 {
                suggestedProducts[suggestedMatch].isInCart = true
            }
            suggestedProducts[suggestedMatch].inCartCount += 1
        }
        interactor.addProductToCart(product: product)
    }
    
    func didTapRemoveButtonFromCell(product: Product) {
        if let match = products.firstIndex(where: { $0.id == product.id }) {
            products[match].inCartCount -= 1
            if products[match].inCartCount == 0 {
                products[match].isInCart = false
            }
        }
        if let suggestedMatch = suggestedProducts.firstIndex(where: { $0.id == product.id}) {
            suggestedProducts[suggestedMatch].inCartCount -= 1
            if suggestedProducts[suggestedMatch].inCartCount == 0 {
                suggestedProducts[suggestedMatch].isInCart = false
            }
        }
        interactor.removeProductFromCart(product: product)
    }
    
   
    
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    
    func updatedProductsOutput(products: [Product]) {
        self.products = products
    }
    
    func updatedSuggestedProductsOutput(products: [Product]) {
        self.suggestedProducts = products
    }
    
    func getProductsOutput(products: [Product]) {
        self.products = products
        interactor.updateCartStatusOfProducts(products: products)
        if !self.suggestedProducts.isEmpty {
            view.hideLoadingView()
            view.reloadData()
        }
    }
    
    func getsuggestedProductsOutput(suggestedProducts: [Product]) {
        self.suggestedProducts = suggestedProducts
        interactor.updateCartStatusOfSuggestedProducts(products: suggestedProducts)
        if !self.products.isEmpty {
            view.hideLoadingView()
            view.reloadData()
        }
    }
    
}

