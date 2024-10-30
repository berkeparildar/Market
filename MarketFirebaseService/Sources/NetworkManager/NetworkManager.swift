//
//  NetworkManager.swift
//
//
//  Created by Berke Parıldar on 29.10.2024.
//

import Foundation
import FirebaseFirestore

public protocol NetworkManagerProtocol {
    func fetchProducts(completion: @escaping (Result<[CategoryAPI], Error>) -> Void)
    func fetchCategories(completion: @escaping (Result<[ProductAPI], Error>) -> Void)
}

public final class NetworkManager {
    
    private init() {}
    
    public func initializeFirebase() {
        FirebaseApp.configure()
    }
        
    public func fetchCategories(completion: @escaping (Result<[CategoryAPI], Error>) -> Void) {
        
    }
    
    public func fetchProducts(route: String, completion: @escaping (Result<[ProductAPI], Error>) -> Void) {
        
    }
}
