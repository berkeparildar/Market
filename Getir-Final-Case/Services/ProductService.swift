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
    func getProducts(completion: @escaping ([Product]) -> Void)
    func getSuggestedProducts(completion: @escaping ([Product]) -> Void)
    func updateFetchedProducts(currentProducts: [Product], coreDataProducts: [Product]) -> [Product]
}

protocol CartUpdateDelegate {
    func didAddProductToCart(product: Product)
    func didRemoveProductFromCart(product: Product)
}

class ProductService {

    private let networkManager = NetworkManager()
    private let dataManager = DataManager()
    static let shared = ProductService()

}

extension ProductService {
    
    func getProducts(completion: @escaping ([Product]) -> Void) {
        networkManager.fetchProducts() { result in
            switch result {
            case .success(let APIproducts):
                let generatedProducts = self.buildProducts(apiProducts: APIproducts)
                completion(generatedProducts)
            case .failure(_):
                print("There was an error fetching")
            }
        }
    }
    
    func getSuggestedProducts(completion: @escaping ([Product]) -> Void) {
        networkManager.fetchSuggestedProducts() { result in
            switch result {
            case .success(let APIproducts):
                let generatedProducts = self.buildProducts(apiProducts: APIproducts)
                completion(generatedProducts)
            case .failure(_):
                print("There was an error fetching")
            }
        }
    }
    
    func buildProducts(apiProducts: [ProductAPI]?)  -> [Product] {
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
}
