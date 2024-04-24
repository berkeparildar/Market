//
//  ProductService.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 20.04.2024.
//

import Foundation
import ProductsAPI

protocol ProductServiceProtocol {
    func getProducts(completion: @escaping ProductsCompletion)
    func getSuggestedProducts(completion: @escaping ProductsCompletion)
    func buildProducts(apiProducts: [ProductAPI]?)  -> [Product]
}

final class ProductService {

    private let networkManager = NetworkManager() // Network Manager fetched the API models to this service
    static let shared = ProductService()
    
}

extension ProductService: ProductServiceProtocol {
    
    /* These two functions fetches the data from the API, uses the buildProducts() method of this class to
     turn the API models to the models that will be used by the modules. Called from the interactor of Listing Page*/
    func getProducts(completion: @escaping ProductsCompletion) {
        networkManager.fetchProducts() { [weak self] result in
            switch result {
            case .success(let APIproducts):
                guard let self = self else { return }
                let generatedProducts = self.buildProducts(apiProducts: APIproducts)
                completion(generatedProducts)
            case .failure(_):
                debugPrint("There was an error fetching")
            }
        }
    }
    
    func getSuggestedProducts(completion: @escaping ProductsCompletion) {
        networkManager.fetchSuggestedProducts() { [weak self] result in
            switch result {
            case .success(let APIproducts):
                guard let self = self else { return }
                let generatedProducts = self.buildProducts(apiProducts: APIproducts)
                completion(generatedProducts)
            case .failure(_):
                debugPrint("There was an error fetching")
            }
        }
    }
    
    /*This function converts the freshly fetched API models to the model that will be used by the modules.
     The ProductAPI models are converted the Product models with non-optional values with nil checking*/
    // See Product model in ProductListing module's entity file.
    func buildProducts(apiProducts: [ProductAPI]?) -> [Product] {
        var generatedProducts = [Product]()
        if let fetchedProducts = apiProducts {
            generatedProducts = fetchedProducts.map {
                let id = $0.id  ?? "5d6d2c696deb8b00011f7665"
                let name = $0.name ?? "Kuzeyden"
                let description = $0.shortDescription ?? $0.attribute ?? ""
                let price = $0.price ?? 59.2
                let priceText = $0.priceText ?? "59.2"
                let imageURL = $0.imageURL ?? $0.squareThumbnailURL ?? $0.thumbnailURL ?? URL(string: "https://market-product-images-cdn.getirapi.com/product/62a59d8a-4dc4-4b4d-8435-643b1167f636.jpg")!
                return Product(id: id, productName: name, productDescription: description, productPrice: price, productPriceText: priceText, isInCart: false, quantityInCart: 0, imageURL: imageURL)
            }
            return generatedProducts
        }
        return generatedProducts
    }
}
