//
//  ProductCellPresenter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

protocol ProductCellPresenterProtocol {
    func getProduct() -> Product?
    func productCount() -> Int?
    func expanded() -> Bool?
    func tappedAdd()
    func tappedRemove()
}

final class ProductCellPresenter {
    var product: Product
    
    unowned var view: ProductCellViewProtocol!
    let interactor: ProductCellInteractorProtocol!
    
    init(interactor: ProductCellInteractorProtocol!, view: ProductCellViewProtocol!, product: Product) {
        self.interactor = interactor
        self.view = view
        self.product = product
    }
}

extension ProductCellPresenter: ProductCellPresenterProtocol {
    func getProduct() -> Product? {
        return self.product
    }
    
    func productCount() -> Int? {
        return product.cartStatus?.count
    }
    
    func expanded() -> Bool? {
        return product.cartStatus?.isInCart
    }
    
    func fetchImage() {
        if let url = product.thumbnailURL ?? product.squareThumbnailURL ?? product.imageURL {
            interactor.fetchImage(url: url)
        }
        else {
        }
    }
    
    func tappedAdd() {
        product.cartStatus!.isInCart = true
        product.cartStatus!.count! += 1
        view.updateAddSection(isExpanded: true)
        view.updateQuantityLabel()
        view.setDeleteButtonImage()
        interactor.tappedAddButton(product: product)
    }
    
    
    func tappedRemove() {
        if product.cartStatus!.count == 1 {
            product.cartStatus!.count! = 0
            product.cartStatus!.isInCart! = false
            view.updateAddSection(isExpanded: false)
        }
        else {
            product.cartStatus!.count! -= 1
            if product.cartStatus!.count == 1 {
                view.setDeleteButtonImage()
            }
        }
        view.updateQuantityLabel()
        interactor.tappedRemoveButton(product: product)
    }
}

extension ProductCellPresenter: ProductCellInteractorOutputProtocol {
    func imageData(output: Data) {
        DispatchQueue.main.async {
            self.view.setProductImage(imageData: output)
        }
    }
}
