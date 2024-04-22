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
    func didAddOrRemoveSuggestedProduct()
    func addButtonTappedFromSuggested(product: Product)
    func deleteButtonTappedFromSuggested(product: Product)
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
    
    func didAddOrRemoveSuggestedProduct() {
        interactor.fetchProductsInCart()
        interactor.fetchSuggestedProducts()
        self.suggestedProducts = CartService.shared.updateCartStatusOfProducts(products: suggestedProducts)
        view.reloadData()
    }
    
    func addButtonTappedFromSuggested(product: Product) {
        guard let matchIndex = self.productsInCart.firstIndex(where: { $0.id == product.id }) else {
            self.productsInCart.append(product)
            self.productsInCart[productsInCart.count - 1].inCartCount = 1
            self.productsInCart[productsInCart.count - 1].isInCart = true
            let indexPath = IndexPath(item: productsInCart.count - 1, section: 0)
            let suggestedIndex = self.suggestedProducts.firstIndex(where: { $0.id == product.id })
            self.suggestedProducts[suggestedIndex!].inCartCount += 1
            self.suggestedProducts[suggestedIndex!].isInCart = true
            view.insertCartItem(at: indexPath)
            view.updateTotalPrice(price: calculateTotalPrice())
            return
        }
        self.productsInCart[matchIndex].inCartCount += 1
        let suggestedIndex = self.suggestedProducts.firstIndex(where: { $0.id == product.id })
        self.suggestedProducts[suggestedIndex!].inCartCount += 1
        let indexPath = IndexPath(item: matchIndex, section: 0)
        view.reloadCartItem(at: indexPath)
        view.updateTotalPrice(price: calculateTotalPrice())
    }
    
    func deleteButtonTappedFromSuggested(product: Product) {
        guard let matchIndex = self.productsInCart.firstIndex(where: { $0.id == product.id }) else { return }
        self.productsInCart[matchIndex].inCartCount -= 1
        if self.productsInCart[matchIndex].inCartCount == 0 {
            self.productsInCart.remove(at: matchIndex)
            let indexPath = IndexPath(item: matchIndex, section: 0)
            view.deleteCartItem(at: indexPath)
        } else {
            let indexPath = IndexPath(item: matchIndex, section: 0)
            view.reloadCartItem(at: indexPath)
        }
        let suggestedIndex = self.suggestedProducts.firstIndex(where: { $0.id == product.id })
        self.suggestedProducts[suggestedIndex!].inCartCount -= 1
        view.updateTotalPrice(price: calculateTotalPrice())
    }
    
    func viewDidLoad() {
        view.setTitle()
        view.setupViews()
        view.setupConstraints()
        view.updateTotalPrice(price: calculateTotalPrice())
    }
    
    func viewWillAppear() {
        interactor.fetchProductsInCart()
        interactor.fetchSuggestedProducts()
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
        if let suggestedMatch = self.suggestedProducts.firstIndex(where: { product.id == $0.id }) {
            self.suggestedProducts[suggestedMatch].inCartCount -= 1
            if self.suggestedProducts[suggestedMatch].inCartCount == 0 {
                self.suggestedProducts[suggestedMatch].isInCart = false
            }
            let indexPath = IndexPath(item: suggestedMatch, section: 1)
            view.reloadCartItem(at: indexPath)
        }
        if self.productsInCart[match!].inCartCount == 0 {
            self.productsInCart.remove(at: match!)
            let indexPath = IndexPath(item: match!, section: 0)
            view.deleteCartItem(at: indexPath)
        }
        view.updateTotalPrice(price: calculateTotalPrice())
    }
}
