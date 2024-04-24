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
    func addProductToCart(product: Product)
}
/*This class handles all the operations regarding CoreData, and is used by CartService.*/
final class DataManager: DataManagerProtocol {
    
    private let coreDataStack = CoreDataStack()
    
    // Function for fetching the products that were in the cart from CoreData.
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
                let count = result.value(forKey: "quantityInCart") as? Int ?? 1
                let price = result.value(forKey: "productPrice") as? Double ?? 0.0
                let imageURL = result.value(forKey: "imageURL") as? URL ?? URL(string: "https://market-product-images-cdn.getirapi.com/product/62a59d8a-4dc4-4b4d-8435-643b1167f636.jpg")!
                let product = Product(id: id, productName: name, productDescription: description, productPrice: price, productPriceText: priceText, isInCart: true, quantityInCart: count, imageURL: imageURL)
                products.append(product)
            }
            return products
        } catch {
            debugPrint("There was an error fetching cart.")
        }
        return products
    }
    
    /* Function for updating the given product in the core data after removal from Cart.
     Note that removal means removing a single product, since the add or removal operations can not be done
     by bulk in the interface. This fuction updates the product's quantityInCart value, decreasing it by one.
     If the quantityInCart is zero, product is removed from CoreData*/
    func removeProductFromCart(product: Product) {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id)
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
    
    /* Function for deleting the entire saved data in CoreData. This is called when order is completed, or the
    Trash button in Cart Page is tapped. */
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
    
    /* Function for updating the given product in the core data after its been added to Cart.
     Note that adding can means adding a single product to cart, does not necesarrily mean adding a new product
     that already was not in the cart. This fuction checks if the given product is already saved in CoreData using
     its id. If it is, it increases its count by one. If not, it creates a new product with updated cart attributes
     and saves it. */
    func addProductToCart(product: Product) {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id)
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
            }
            coreDataStack.saveContext()
        } catch {
            debugPrint("There was an error adding product to cart with id: \(product.id)")
        }
    }
}
