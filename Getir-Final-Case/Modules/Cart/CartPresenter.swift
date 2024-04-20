//
//  CartPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

protocol CartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfProductsInCart() -> Int
    func numberOfSuggestedProducts() -> Int
    func productInCart(_ index: Int) -> Product
    func suggestedProduct(_ index: Int) -> Product
    func tappedSuggestedProduct(index: Int)
    func didTapTrashButton()
}

final class CartPresenter {
    unowned var view: CartViewControllerProtocol!
    let interactor: CartInteractorProtocol!
    let router: CartRouterProtocol!
    
    private var productsInCart: [Product] = []
    private var suggestedProducts: [Product] = []
    
    init(view: CartViewControllerProtocol!, router: CartRouterProtocol!, interactor: CartInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension CartPresenter: CartPresenterProtocol {
    func viewDidLoad() {
        view.setTitle()
        view.setupViews()
        view.setupConstraints()
        view.updateTotalPrice(price: calculateTotalPrice())
    }
    
    func viewWillAppear() {
        interactor.fetchProductsInCart()
        interactor.fetchSuggestedProducts()
        self.suggestedProducts = ProductService.shared.updateFetchedProducts(currentProducts: self.suggestedProducts, coreDataProducts: productsInCart)
    }
    
    func numberOfProductsInCart() -> Int {
        return productsInCart.count
    }
    
    func numberOfSuggestedProducts() -> Int {
        return suggestedProducts.count
    }
    
    func productInCart(_ index: Int) -> Product {
        return productsInCart[safe: index]!
    }
    
    func suggestedProduct(_ index: Int) -> Product {
        return suggestedProducts[safe: index]!
    }
    
    func tappedSuggestedProduct(index: Int) {
        router.navigate(.detail(product: suggestedProduct(index)))
    }
    
    func didTapTrashButton() {
        
    }
    
    func calculateTotalPrice() -> Double {
        var totalPrice = 0.0
        productsInCart.forEach {
            totalPrice += ($0.productPrice * Double($0.inCartCount))
        }
        return totalPrice
    }
}

extension CartPresenter: CartInteractorOutputProtocol {
    func fetchSuggestedProductsOutput(result: [Product]) {
        self.suggestedProducts = result
        view.reloadData()
    }
    func fetchProductsInCartOutput(result: [Product]) {
        self.productsInCart = result
        view.reloadData()
    }
}

extension CartPresenter: UpdateCartViewProtocol {
    func addButtonTapped(product: Product) {
        let match = self.productsInCart.firstIndex { product.id == $0.id }
        self.productsInCart[match!].inCartCount += 1
        let suggestedMatch = self.suggestedProducts.firstIndex { product.id == $0.id }
        self.suggestedProducts[suggestedMatch!].inCartCount += 1
        view.updateTotalPrice(price: calculateTotalPrice())
        view.reloadData()
    }
    
    func deleteButtonTapped(product: Product) {
        let match = self.productsInCart.firstIndex { product.id == $0.id }
        self.productsInCart[match!].inCartCount -= 1
        if self.productsInCart[match!].inCartCount == 0 {
            self.productsInCart.remove(at: match!)
        }
        view.updateTotalPrice(price: calculateTotalPrice())
        view.reloadData()
    }
}
