//
//  CartRepository.swift
//  Market-App
//
//  Created by Berke Parıldar on 14.04.2024.
//

import UIKit
import CoreData


protocol DataManagerProtocol {
    func fetchCart() -> [Product]
    func removeProductFromCart(product: Product)
    func addProductToCart(product: Product)
}

final class DataManager: DataManagerProtocol {
    private let coreDataStack = CoreDataStack()
    func fetchCart() -> [Product] {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "isInCart == YES")
        var products = [Product]()
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                let id = result.value(forKey: "id") as! Int
                let name = result.value(forKey: "productName") as! String
                let description = result.value(forKey: "productDescription") as! String
                let priceText = result.value(forKey: "productPriceText") as! String
                let count = result.value(forKey: "quantityInCart") as! Int
                let price = result.value(forKey: "productPrice") as! Double
                let imageURL = result.value(forKey: "imageURL") as! String
                let categoryID = result.value(forKey: "categoryID") as! String
                let product = Product(id: id, productName: name, productDescription: description, productPrice: price, productPriceText: priceText, isInCart: true, quantityInCart: count, imageURL: imageURL, categoryID: categoryID)
                products.append(product)
            }
            return products
        } catch {
            debugPrint("There was an error fetching cart.")
        }
        return products
    }

    func removeProductFromCart(product: Product) {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %d", product.id)
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            guard let result = results.first else { return }
            var count = result.value(forKey: "quantityInCart") as? Int ?? 1
            count -= 1
            result.setValue(count, forKey: "quantityInCart")
            if count == .zero {
                context.delete(result)
            }
            coreDataStack.saveContext()
        } catch {
            debugPrint("There was an error removing product from cart with id: \(product.id)")
        }
    }
    
    func clearCart() {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for object in results {
                context.delete(object)
            }
            coreDataStack.saveContext()
        } catch {
            debugPrint("There was an error clearing the cart database.")
        }
    }
    
    func addProductToCart(product: Product) {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %d", product.id)
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            if !results.isEmpty {
                guard let result = results.first else { return }
                var currentCount = result.value(forKey: "quantityInCart") as? Int ?? 1
                currentCount += 1
                result.setValue(currentCount, forKey: "quantityInCart")
            }
            else {
                let newProduct = NSEntityDescription.insertNewObject(forEntityName: "CartProduct", into: context)
                newProduct.setValue(product.id, forKey: "id")
                newProduct.setValue(product.productName, forKey: "productName")
                newProduct.setValue(product.productDescription, forKey: "productDescription")
                newProduct.setValue(product.productPriceText, forKey: "productPriceText")
                newProduct.setValue(product.productPrice, forKey: "productPrice")
                newProduct.setValue(1, forKey: "quantityInCart")
                newProduct.setValue(true, forKey: "isInCart")
                newProduct.setValue(product.imageURL, forKey: "imageURL")
                newProduct.setValue(product.categoryID, forKey: "categoryID")
            }
            coreDataStack.saveContext()
        } catch {
            debugPrint("There was an error adding product to cart with id: \(product.id)")
        }
    }
}
