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
    func fetchProducts()
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
    
    // Returns the product with the given index, used assigning product to collection view cells.
    func getProduct(_ index: Int) -> Product {
        return products[safe: index]!
    }
    // Returns the suggested product with the given index, used assigning product to collection view cells.
    func getSuggestedProduct(_ index: Int) -> Product {
        return suggestedProducts[safe: index]!
    }
    
    // Returns the number of products, used for collectionView's cell count
    func getProductCount() -> Int {
        return products.count
    }
    
    // Returns the number of suggested products, used for collectionView's cell count
    func getSuggestedProductCount() -> Int {
        return suggestedProducts.count
    }
    
    /* Function for handling the tap from the collection view, call's router's navigate function to Product Detail
     page, with the product tapped. Gets the product from either one of it's array according to the section of cell*/
    func didSelectItemAt(indexPath: IndexPath) {
        if indexPath.section == 0 {
            router.navigate(.detail(product: suggestedProducts[indexPath.item]))
        }
        else {
            router.navigate(.detail(product: products[indexPath.item]))
        }
    }
    /* Function for handling the tap on the cart button, navigates to the Cart View, passes the suggested products
     it currently holds, so that Cart won't need to fetch it. */
    func didTapCartButton() {
        router.navigate(.cart(suggestedProducts: self.suggestedProducts))
    }

    /* Function for fetching the products, loading view is shown for this process. */
     func fetchProducts() {
        view.showLoadingView()
        interactor.fetchProducts()
    }
    
    /* The add and remove functions that are called when the user taps on one of the buttons on the cell. This
     function updates the quantityInCart and isInCart attributes of the products, and tells interactor to update the
     cart using CartService */
    func didTapAddButtonFromCell(product: Product) {
        if let match = products.firstIndex(where: { $0 == product }) {
            if products[match].quantityInCart == 0 {
                products[match].isInCart = true
            }
            products[match].quantityInCart += 1
        }
        if let suggestedMatch = suggestedProducts.firstIndex(where: { $0 == product }) {
            if suggestedProducts[suggestedMatch].quantityInCart == 0 {
                suggestedProducts[suggestedMatch].isInCart = true
            }
            suggestedProducts[suggestedMatch].quantityInCart += 1
        }
        interactor.addProductToCart(product: product)
    }
    
    func didTapRemoveButtonFromCell(product: Product) {
        if let match = products.firstIndex(where: { $0 == product }) {
            products[match].quantityInCart -= 1
            if products[match].quantityInCart == 0 {
                products[match].isInCart = false
            }
        }
        if let suggestedMatch = suggestedProducts.firstIndex(where: { $0 == product}) {
            suggestedProducts[suggestedMatch].quantityInCart -= 1
            if suggestedProducts[suggestedMatch].quantityInCart == 0 {
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

