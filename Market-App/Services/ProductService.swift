//
//  ProductService.swift
//  Market-App
//
//  Created by Berke Parıldar on 20.04.2024.
//

import Foundation
import ProductsAPI
final class ProductService {
    private let networkManager = NetworkManager()
    static let shared = ProductService()
}

extension ProductService {
    func getProducts(completion: @escaping ([Category]) -> Void) {
        networkManager.fetchCategories { [weak self] result in
            guard let self = self else { return }
            var categories = [Category]()
            let dispatchGroup = DispatchGroup()
            switch result {
            case .success(let categoriesFromAPI):
                for categoryFromAPI in categoriesFromAPI {
                    dispatchGroup.enter()
                    self.networkManager.fetchProducts(route: categoryFromAPI.route!) { result in
                        switch result {
                        case .success(let productsFromAPI):
                            let products = self.buildProducts(apiProducts: productsFromAPI)
                            let category = Category(
                                id: categoryFromAPI.id!,
                                name: categoryFromAPI.name!,
                                image: categoryFromAPI.image!,
                                route: categoryFromAPI.route!,
                                products: products
                            )
                            categories.append(category)
                        case .failure(let error):
                            print("Error fetching products for category: \(String(describing: categoryFromAPI.route)) - \(error.localizedDescription)")
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(categories)
                }
            case .failure(let error):
                print("Error fetching categories: \(error.localizedDescription)")
            }
        }
    }
    
    func getProductsFromCategory(id: String, completion: @escaping ([Product]) -> Void) {
        networkManager.fetchProducts(route: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let productsFromAPI):
                let products = self.buildProducts(apiProducts: productsFromAPI)
                completion(products)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func buildProducts(apiProducts: [ProductAPI]?) -> [Product] {
        var generatedProducts = [Product]()
        
        if let fetchedProducts = apiProducts {
            for apiProduct in fetchedProducts {
                if let id = apiProduct.id,
                   let name = apiProduct.name,
                   let description = apiProduct.description,
                   let price = apiProduct.price,
                   let priceText = apiProduct.priceText,
                   let imageURL = apiProduct.image,
                   let categoryID = apiProduct.categoryID{
                    let product = Product(
                        id: id,
                        productName: name,
                        productDescription: description,
                        productPrice: price,
                        productPriceText: priceText,
                        isInCart: false,
                        quantityInCart: 0,
                        imageURL: imageURL,
                        categoryID: categoryID
                    )
                    generatedProducts.append(product)
                }
            }
        }
        return generatedProducts
    }
}
