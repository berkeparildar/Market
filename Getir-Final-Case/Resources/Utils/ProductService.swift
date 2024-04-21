//
//  ProductService.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 20.04.2024.
//

import Foundation
import Network

protocol ProductServiceProtocol {
    func createProductModels(apiProducts: [ProductAPI]?)  -> [Product]
    func fetchProducts(completion: @escaping ([Product]) -> Void)
    func fetchSuggestedProducts(completion: @escaping ([Product]) -> Void)
    func addToCart(product: Product)
    func removeFromCart(product: Product)
    func fetchCartProducts() -> [Product]
    func updateFetchedProducts(currentProducts: [Product], coreDataProducts: [Product]) -> [Product]
}

protocol CartUpdateDelegate {
    func didAddProductToCart(product: Product)
    func didRemoveProductFromCart(product: Product)
}

class ProductService {

    private let networkManager = NetworkManager()
    private var dataManager = DataManager()
    
    static let shared = ProductService()
 
}

extension ProductService: ProductServiceProtocol {
    
    func fetchProducts(completion: @escaping ([Product]) -> Void) {
        networkManager.fetchProducts() { result in
            switch result {
            case .success(let APIproducts):
                let generatedProducts = self.createProductModels(apiProducts: APIproducts)
                let coreDataProducts = self.fetchCartProducts()
                let updatedProducts = self.updateFetchedProducts(currentProducts: generatedProducts, coreDataProducts: coreDataProducts)
                completion(updatedProducts)
            case .failure(_):
                print("There was an error fetching")
            }
        }
    }
    
    func fetchSuggestedProducts(completion: @escaping ([Product]) -> Void) {
        networkManager.fetchSuggestedProducts() { result in
            switch result {
            case .success(let APIproducts):
                let generatedProducts = self.createProductModels(apiProducts: APIproducts)
                let coreDataProducts = self.dataManager.fetchCart()
                let updatedProducts = self.updateFetchedProducts(currentProducts: generatedProducts, coreDataProducts: coreDataProducts)
                completion(updatedProducts)
            case .failure(_):
                print("There was an error fetching")
            }
        }
    }
    
    func addToCart(product: Product) {
        dataManager.addProductToCart(product: product)
    }
    
    func removeFromCart(product: Product) {
        dataManager.removeProductFromCart(product: product)
    }
    
    func fetchCartProducts() -> [Product] {
        return dataManager.fetchCart()
    }
    
    func fetchFromCartWithID(id: String) -> Product? {
        var product = dataManager.fetchProductWithID(id: id)
        return product
    }
    
    func createProductModels(apiProducts: [ProductAPI]?)  -> [Product] {
        var generatedProducts = [Product]()
        if let fetchedProducts = apiProducts {
            generatedProducts = fetchedProducts.map {
                let id = $0.id  ?? "5d6d2c696deb8b00011f7665"
                let name = $0.name ?? "Kuzeyden"
                let description = $0.shortDescription ?? $0.attribute ?? "2 x 5 L"
                let price = $0.price ?? 59.2
                let priceText = $0.priceText ?? "59.2"
                let imageURL = $0.imageURL ?? $0.squareThumbnailURL ?? $0.thumbnailURL ?? URL(string: "https://market-product-images-cdn.getirapi.com/product/62a59d8a-4dc4-4b4d-8435-643b1167f636.jpg")!
                return Product(id: id, productName: name, productDescription: description, productPrice: price, productPriceText: priceText, isInCart: false, inCartCount: 0, imageURL: imageURL)
            }
            return generatedProducts
        }
        return generatedProducts
    }
    
    func updateFetchedProducts(currentProducts: [Product], coreDataProducts: [Product]) -> [Product] {
        var updatedProducts = [Product]()
        for generatedProduct in currentProducts {
            if let match = coreDataProducts.first(where: { $0.id == generatedProduct.id}) {
                updatedProducts.append(match)
            }
            else {
                updatedProducts.append(Product(id: generatedProduct.id, productName: generatedProduct.productName, productDescription: generatedProduct.productDescription, productPrice: generatedProduct.productPrice, productPriceText: generatedProduct.productPriceText, isInCart: false, inCartCount: 0, imageURL: generatedProduct.imageURL))
            }
        }
        return updatedProducts
    }
}
