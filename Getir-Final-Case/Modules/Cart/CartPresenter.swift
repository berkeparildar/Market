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
    func tappedProduct(indexpath: IndexPath)
    func didTapTrashButton()
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
    
    func addButtonTappedFromSuggested(product: Product) {
        if let matchIndex = self.productsInCart.firstIndex(where: { $0.id == product.id }) {
            self.productsInCart[matchIndex].inCartCount += 1
            let cartIndexPath = IndexPath(item: matchIndex, section: 0)
            view.reloadCartItem(at: cartIndexPath)
        } else {
            self.productsInCart.append(product)
            self.productsInCart[productsInCart.count - 1].inCartCount = 1
            self.productsInCart[productsInCart.count - 1].isInCart = true
            let newCartIndexPath = IndexPath(item: productsInCart.count - 1, section: 0)
            view.insertCartItem(at: newCartIndexPath)
        }
        if let suggestedIndex = self.suggestedProducts.firstIndex(where: { $0.id == product.id }) {
            self.suggestedProducts.remove(at: suggestedIndex)
            let suggestedIndexPath = IndexPath(item: suggestedIndex, section: 1)
            view.deleteCartItem(at: suggestedIndexPath)
        }
        view.updateTotalPrice(price: calculateTotalPrice())
    }
    
    func viewDidLoad() {
        view.setupNavigationBar()
        view.setupViews()
        view.setupConstraints()
        view.updateTotalPrice(price: calculateTotalPrice())
    }
    
    func viewWillAppear() {
        interactor.fetchProductsInCart()
        interactor.fetchSuggestedProducts()
        view.updateTotalPrice(price: calculateTotalPrice())
        self.suggestedProducts = CartService.shared.updateCartStatusOfProducts(products: suggestedProducts)
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
    
    func tappedProduct(indexpath: IndexPath) {
        if indexpath.section == 0 {
            router.navigate(.detail(product: productInCart(indexpath.item)))
        }
        else {
            router.navigate(.detail(product: suggestedProduct(indexpath.item)))
        }
    }
    
    func didTapTrashButton() {
        interactor.clearCart()
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
        self.suggestedProductsFetched = result
        self.suggestedProducts = self.suggestedProductsFetched
        for product in self.productsInCart {
            if let match = self.suggestedProducts.firstIndex(where: { $0.id == product.id}) {
                suggestedProducts.remove(at: match)
            }
        }
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
        if let suggestedMatch = self.suggestedProducts.firstIndex(where: { product.id == $0.id }) {
            self.suggestedProducts[suggestedMatch].inCartCount += 1
            let indexPath = IndexPath(item: suggestedMatch, section: 1)
            view.reloadCartItem(at: indexPath)
        }
        view.updateTotalPrice(price: calculateTotalPrice())
    }
    
    func deleteButtonTapped(product: Product) {
        let match = self.productsInCart.firstIndex { product.id == $0.id }
        self.productsInCart[match!].inCartCount -= 1
        if self.productsInCart[match!].inCartCount == 0 {
            if let suggestedMatch = self.suggestedProductsFetched.firstIndex(where: { product.id == $0.id }) {
                self.suggestedProducts.insert(self.suggestedProductsFetched[suggestedMatch], at: 0)
                let indexPath = IndexPath(item: 0, section: 1)
                view.insertCartItem(at: indexPath)
            }
            self.productsInCart.remove(at: match!)
            let indexPath = IndexPath(item: match!, section: 0)
            view.deleteCartItem(at: indexPath)
        }
        view.updateTotalPrice(price: calculateTotalPrice())
    }
}
