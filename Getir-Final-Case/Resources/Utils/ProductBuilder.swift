//
//  ProductBuilder.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

class ProductBuilder {
    
    static let shared = ProductBuilder()
    
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
    
    func updateCartStatus(generatedProducts: [Product], coreDataProducts: [Product]) -> [Product] {
        var updatedProducts = [Product]()
        for generatedProduct in generatedProducts {
            if let match = coreDataProducts.first(where: { $0.id == generatedProduct.id}) {
                updatedProducts.append(match)
            }
            else {
                updatedProducts.append(generatedProduct)
            }
        }
        return updatedProducts
    }
}
