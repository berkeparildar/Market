//
//  CartPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

protocol CartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func getProductInCart(_ index: Int) -> Product
    func getProductInCartCount() -> Int
    func getSuggestedProduct(_ index: Int) -> Product
    func getSuggestedProductCount() -> Int
    func didSelectItemAt(indexpath: IndexPath)
    func didTapTrashButton()
    func addButtonTappedFromCart(product: Product)
    func removeButtonTappedFromCart(product: Product)
    func addButtonTappedFromSuggested(product: Product)
}

final class CartPresenter {
    unowned var view: CartViewControllerProtocol!
    let interactor: CartInteractorProtocol!
    let router: CartRouterProtocol!
    
    private var productsInCart: [Product] = []
    private var suggestedProducts: [Product] = []
    private var suggestedProductsFetched: [Product] = []
    
    init(view: CartViewControllerProtocol!, router: CartRouterProtocol!, interactor: CartInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension CartPresenter: CartPresenterProtocol {
    
    func viewDidLoad() {
        view.setupViews()
        view.setupConstraints()
    }
    
    func viewWillAppear() {
        view.setupNavigationBar()
        interactor.fetchProductsInCart()
        view.updateTotalPrice(price: calculateTotalPrice(), isAnimated: false)
    }
    
    func getProductInCart(_ index: Int) -> Product {
        return productsInCart[safe: index]!
    }
    
    func getSuggestedProduct(_ index: Int) -> Product {
        return suggestedProducts[safe: index]!
    }
    
    func getProductInCartCount() -> Int {
        return productsInCart.count
    }
    
    func getSuggestedProductCount() -> Int {
        return suggestedProducts.count
    }
    
    func didSelectItemAt(indexpath: IndexPath) {
        if indexpath.section == 0 {
            router.navigate(.detail(product: getProductInCart(indexpath.item)))
        }
        else {
            router.navigate(.detail(product: getSuggestedProduct(indexpath.item)))
        }
    }
    
    func didTapTrashButton() {
        interactor.clearCart(products: productsInCart)
    }
    
    func calculateTotalPrice() -> Double {
        var totalPrice = 0.0
        productsInCart.forEach {
            totalPrice += ($0.productPrice * Double($0.quantityInCart))
        }
        return totalPrice
    }
    
    func addButtonTappedFromCart(product: Product) {
        view.updateTotalPrice(price: calculateTotalPrice(), isAnimated: true)
        interactor.addProductToCart(product: product)
    }
    
    func removeButtonTappedFromCart(product: Product) {
        let index = productsInCart.firstIndex(where: {$0 == product})!
        interactor.removeProductFromCart(product: product)
        interactor.fetchProductsInCart()
        view.updateTotalPrice(price: calculateTotalPrice(), isAnimated: true)
        if product.quantityInCart == 0 {
            let indexPath = IndexPath(item: index, section: 0)
            view.deleteCartItem(at: indexPath)
        }
    }
    
    func addButtonTappedFromSuggested(product: Product) {
        interactor.addProductToCart(product: product)
        interactor.fetchProductsInCart()
        view.updateTotalPrice(price: calculateTotalPrice(), isAnimated: true)
        let newCartIndexPath = IndexPath(item: productsInCart.count - 1, section: 0)
        view.insertCartItem(at: newCartIndexPath)
        if let suggestedIndex = self.suggestedProducts.firstIndex(where: { $0 == product }) {
            self.suggestedProducts.remove(at: suggestedIndex)
            let suggestedIndexPath = IndexPath(item: suggestedIndex, section: 1)
            view.deleteCartItem(at: suggestedIndexPath)
        }
    }
}

extension CartPresenter: CartInteractorOutputProtocol {    
    func fetchSuggestedProductsOutput(result: [Product]) {
        self.suggestedProductsFetched = result
        self.suggestedProducts = self.suggestedProductsFetched
        view.reloadData()
    }
    
    func fetchProductsInCartOutput(result: [Product]) {
        self.productsInCart = result
        view.reloadData()
        if productsInCart.isEmpty {
            interactor.clearCart(products: productsInCart)
            view.goBackToListing()
        }
    }
}
