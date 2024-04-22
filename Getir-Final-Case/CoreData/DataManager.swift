//
//  CartRepository.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import UIKit
import CoreData


protocol DataManagerProtocol {
    func fetchCart() -> [Product]
    func removeProductFromCart(product: Product)
    func fetchProductWithID(id: String) -> Product?
    func addProductToCart(product: Product)
}

class DataManager: DataManagerProtocol {
    
    private let coreDataStack = CoreDataStack()
    
    func fetchCart() -> [Product] {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "isInCart == YES")
        var products = [Product]()
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                let id = result.value(forKey: "id") as? String ?? "id"
                let name = result.value(forKey: "productName") as? String ?? "name"
                let description = result.value(forKey: "productDescription") as? String ?? "name"
                let priceText = result.value(forKey: "productPriceText") as? String ?? "0.0"
                let count = result.value(forKey: "inCartCount") as? Int ?? 1
                let price = result.value(forKey: "productPrice") as? Double ?? 0.0
                let imageURL = result.value(forKey: "imageURL") as? URL ?? URL(string: "https://market-product-images-cdn.getirapi.com/product/62a59d8a-4dc4-4b4d-8435-643b1167f636.jpg")!
                let product = Product(id: id, productName: name, productDescription: description, productPrice: price, productPriceText: priceText, isInCart: true, inCartCount: count, imageURL: imageURL)
                products.append(product)
            }
            return products
        } catch {
            print("Save error")
        }
        return products
    }
    
    func fetchProductWithID(id: String) -> Product? {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                let id = result.value(forKey: "id") as? String ?? "id"
                let name = result.value(forKey: "productName") as? String ?? "name"
                let description = result.value(forKey: "productDescription") as? String ?? "name"
                let priceText = result.value(forKey: "productPriceText") as? String ?? "0.0"
                let count = result.value(forKey: "inCartCount") as? Int ?? 1
                let price = result.value(forKey: "productPrice") as? Double ?? 0.0
                let imageURL = result.value(forKey: "imageURL") as? URL ?? URL(string: "https://market-product-images-cdn.getirapi.com/product/62a59d8a-4dc4-4b4d-8435-643b1167f636.jpg")!
                let product = Product(id: id, productName: name, productDescription: description, productPrice: price, productPriceText: priceText, isInCart: true, inCartCount: count, imageURL: imageURL)
                return product
            }
        } catch {
            print("Save error")
        }
        return nil
    }
    
    func removeProductFromCart(product: Product) {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id)
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            guard let result = results.first else { return }
            var count = result.value(forKey: "inCartCount") as? Int ?? 1
            if count > 1 {
                count -= 1
                result.setValue(count, forKey: "inCartCount")
            }
            else {
                context.delete(result)
            }
            coreDataStack.saveContext()
        } catch {
            print("Save error")
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
            print("Delete error: \(error)")
        }
    }
    
    func addProductToCart(product: Product) {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id)
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            if !results.isEmpty {
                guard let result = results.first else { return }
                var currentCount = result.value(forKey: "inCartCount") as? Int ?? 1
                currentCount += 1
                result.setValue(currentCount, forKey: "inCartCount")
            }
            else {
                let newProduct = NSEntityDescription.insertNewObject(forEntityName: "CartProduct", into: context)
                newProduct.setValue(product.id, forKey: "id")
                newProduct.setValue(product.productName, forKey: "productName")
                newProduct.setValue(product.productDescription, forKey: "productDescription")
                newProduct.setValue(product.productPriceText, forKey: "productPriceText")
                newProduct.setValue(product.productPrice, forKey: "productPrice")
                newProduct.setValue(1, forKey: "inCartCount")
                newProduct.setValue(true, forKey: "isInCart")
                newProduct.setValue(product.imageURL, forKey: "imageURL")
            }
            coreDataStack.saveContext()
        } catch {
            print("Save error")
        }
    }
}
