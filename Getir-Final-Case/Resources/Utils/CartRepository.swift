//
//  CartRepository.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import UIKit
import CoreData


protocol CartRepositoryProtocol {
    func fetchCart() -> [CartProduct]?
    func updateProduct(id: String, price: Double, add: Bool)
}

class CartRepository: CartRepositoryProtocol {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let shared = CartRepository()
    
    private init() {}
    
    func fetchCart() -> [CartProduct]? {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartItem")
        fetchRequest.predicate = NSPredicate(format: "isInCart == YES")
        do {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty {
                var products: [CartProduct]!
                for result in results as! [NSManagedObject] {
                    if products == nil {
                        products = [CartProduct]()
                    }
                    let productID = result.value(forKey: "id") as? String ?? "id"
                    let count = result.value(forKey: "count") as? Int ?? 1
                    let price = result.value(forKey: "price") as? Double ?? 0.0
                    
                    let product = CartProduct(id: productID, count: count, isInCart: true, price: price)
                    
                    products.append(product)
                }
                return products
            } else {
                return [CartProduct]()
            }
        } catch {
            print("Save error")
        }
        return [CartProduct]()
    }
    
    func updateProduct(id: String, price: Double, add: Bool) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CartItem")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            if add {
                if !results.isEmpty {
                    guard let result = results.first else { return }
                    var count = result.value(forKey: "count") as? Int ?? 1
                    count += 1
                    result.setValue(count, forKey: "count")
                }
                else {
                    let newProduct = NSEntityDescription.insertNewObject(forEntityName: "CartItem", into: context)
                    newProduct.setValue(id, forKey: "id")
                    newProduct.setValue(price, forKey: "price")
                    newProduct.setValue(1, forKey: "count")
                    newProduct.setValue(true, forKey: "isInCart")
                }
                do {
                    try context.save()
                } catch {
                    print("Save Error")
                }
            }
            else {
                if !results.isEmpty {
                    guard let result = results.first else { return }
                    var count = result.value(forKey: "count") as? Int ?? 1
                    if count > 1 {
                        count -= 1
                        result.setValue(count, forKey: "count")
                    }
                    else {
                        context.delete(result)
                    }
                }
                do {
                    try context.save()
                } catch {
                    print("Save Error")
                }
            }
        } catch _ as NSError {
            print("Save error")
        }
    }
}
