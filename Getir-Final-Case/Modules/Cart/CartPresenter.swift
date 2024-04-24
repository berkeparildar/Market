//
//  CartPresenter.swift
//  Getir-Final-Case
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
        interactor.fetchSuggestedProducts()
        view.updateTotalPrice(price: calculateTotalPrice(), isAnimated: false)
    }
    
    // Returns the product in the cart with the given index, used assigning product to collection view cells.
    func getProductInCart(_ index: Int) -> Product {
        return productsInCart[safe: index]!
    }
    
    // Returns the suggested product with the given index, used assigning product to collection view cells.
    func getSuggestedProduct(_ index: Int) -> Product {
        return suggestedProducts[safe: index]!
    }
    
    // Returns the number of products in cart, used for collectionView's cell count
    func getProductInCartCount() -> Int {
        return productsInCart.count
    }
    
    // Returns the number of suggested products, used for collectionView's cell count
    func getSuggestedProductCount() -> Int {
        return suggestedProducts.count
    }
    
    /* Function for handling the tap from the collection view, call's router's navigate function to Product Detail
     page, with the product tapped. Gets the product from either one of it's array according to the section of cell*/
    func didSelectItemAt(indexpath: IndexPath) {
        if indexpath.section == 0 {
            router.navigate(.detail(product: getProductInCart(indexpath.item)))
        }
        else {
            router.navigate(.detail(product: getSuggestedProduct(indexpath.item)))
        }
    }
    
    /* Function for handling the tap on the trash button, tells interactor to clear the cart using
     Cart Service */
    func didTapTrashButton() {
        interactor.clearCart()
    }
    
    func calculateTotalPrice() -> Double {
        var totalPrice = 0.0
        productsInCart.forEach {
            totalPrice += ($0.productPrice * Double($0.quantityInCart))
        }
        return totalPrice
    }
    
    /* The add and remove functions that are called when the user taps on one of the buttons on the cart cell. This
     function updates the quantityInCart and isInCart attributes of the products, and tells interactor to update the
     cart using CartService. If product's count is 0, it is removed from the array,
     if it was the last product in the cart, the cart is cleaned again via interactor and
     view is popped back to root view controller.*/
    func addButtonTappedFromCart(product: Product) {
        let match = self.productsInCart.firstIndex { product == $0 }
        self.productsInCart[match!].quantityInCart += 1
        view.updateTotalPrice(price: calculateTotalPrice(), isAnimated: true)
        interactor.addProductToCart(product: product)
    }
    
    func removeButtonTappedFromCart(product: Product) {
        let match = self.productsInCart.firstIndex { product == $0 }
        self.productsInCart[match!].quantityInCart -= 1
        if self.productsInCart[match!].quantityInCart == 0 {
            if let suggestedMatch = self.suggestedProductsFetched.firstIndex(where: { product == $0 }) {
                self.suggestedProducts.insert(self.suggestedProductsFetched[suggestedMatch], at: 0)
                let indexPath = IndexPath(item: 0, section: 1)
                view.insertCartItem(at: indexPath)
            }
            self.productsInCart.remove(at: match!)
            let indexPath = IndexPath(item: match!, section: 0)
            view.deleteCartItem(at: indexPath)
        }
        view.updateTotalPrice(price: calculateTotalPrice(), isAnimated: true)
        interactor.removeProductFromCart(product: product)
        if productsInCart.isEmpty {
            interactor.clearCart()
            view.goBackToListing()
        }
    }
    
    /* The add functions that are called when the user taps on the add button on the suggested cell. This
     function updates the quantityInCart and isInCart attributes of the product, and tells interactor to update the
     cart using CartService. The suggested products that are added via this operation is
     added to the cart array, and removed from the suggested products array. Notice that he suggestedProducts array is used
     for add-remove operations, and suggestedProductsFetched is left untouched. This is for later checking if the products was
     in suggested array at first. */
    func addButtonTappedFromSuggested(product: Product) {
        if let matchIndex = self.productsInCart.firstIndex(where: { $0 == product }) {
            self.productsInCart[matchIndex].quantityInCart += 1
            let cartIndexPath = IndexPath(item: matchIndex, section: 0)
            view.reloadCartItem(at: cartIndexPath)
        } else {
            self.productsInCart.append(product)
            self.productsInCart[productsInCart.count - 1].quantityInCart = 1
            self.productsInCart[productsInCart.count - 1].isInCart = true
            let newCartIndexPath = IndexPath(item: productsInCart.count - 1, section: 0)
            view.insertCartItem(at: newCartIndexPath)
        }
        if let suggestedIndex = self.suggestedProducts.firstIndex(where: { $0 == product }) {
            self.suggestedProducts.remove(at: suggestedIndex)
            let suggestedIndexPath = IndexPath(item: suggestedIndex, section: 1)
            view.deleteCartItem(at: suggestedIndexPath)
        }
        view.updateTotalPrice(price: calculateTotalPrice(), isAnimated: true)
        interactor.addProductToCart(product: product)
    }
    
}

extension CartPresenter: CartInteractorOutputProtocol {
    
    func fetchSuggestedProductsOutput(result: [Product]) {
        self.suggestedProductsFetched = result
        self.suggestedProducts = self.suggestedProductsFetched
        for product in self.productsInCart {
            if let match = self.suggestedProducts.firstIndex(where: { $0 == product }) {
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
