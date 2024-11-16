//
//  MarketCartEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 13.11.2024.
//

class MarketCartEntity {
    
    var product: Product
    var quantity: Int
    
    init(product: Product) {
        self.product = product
        self.quantity = 1
    }
    
    func increaseQuantity() {
        quantity += 1
    }
    
    func decreaseQuantity() {
        quantity -= 1
    }
}
