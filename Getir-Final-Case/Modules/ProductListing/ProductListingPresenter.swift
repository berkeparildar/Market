//
//  ProductListingPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import Foundation

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfItemsVertical() -> Int
    func product(_ index: Int) -> Product?
    func didSelectItemAt(index: Int)
    func tappedCart()
    func tappedProduct(_ index: Int)
}

final class ProductListingPresenter {
    
    unowned var view: ProductListingViewControllerProtocol!
    let router: ProductListingRouterProtocol!
    let interactor: ProductListingInteractorProtocol!
    
    private var products: [Product] = []
    
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
    
    func numberOfItemsVertical() -> Int {
        return products.count
    }
    
    func product(_ index: Int) -> Product? {
        return products[safe: index]
    }

    func productIndex(id: String) -> Int? {
        return products.firstIndex {
            $0.id == id
        }
    }
    
    func didSelectItemAt(index: Int) {
        print(products[index].name)
    }
    
    func tappedCart() {
        router.navigate(.cart)
    }
    
    func tappedProduct(_ index: Int) {
        
    }
    
    private func fetchProducts() {
        view.showLoadingView()
        interactor.fetchProducts()
    }
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    func fetchProductsOutput(result: [Product]) {
        view.hideLoadingView()
        self.products = result
        view.reloadData()
    }
}

extension ProductListingPresenter: ProductCellDelegate {
    func didTapAddButton(forProduct product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            if products[index].isExpanded == nil {
                products[index].isExpanded = true
            }
            else {
                products[index].isExpanded?.toggle()
            }
        }
    }
}
