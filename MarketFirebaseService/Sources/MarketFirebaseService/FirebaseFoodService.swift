//
//  FirebaseFoodService.swift
//  MarketFirebaseService
//
//  Created by Berke Parıldar on 18.11.2024.
//

import Foundation
import FirebaseFirestore

public class FirebaseFoodService {
    
    private let db = Firestore.firestore()
    private var restIndex = 0
    
    public init() {}
    
    public func fetchCategories(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let marketDocRef = db.collection("restaurants").document("categories")
        
        marketDocRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "FirestoreService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])))
                return
            }
            
            if let categoriesData = document.data()?["categories"] as? [[String: Any]] {
                completion(.success(categoriesData))
            } else {
                completion(.failure(NSError(domain: "FirestoreService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Categories data not found"])))
            }
        }
    }
    
    public func fetchRestaurants(id: Int, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let marketDocRef = db.collection("restaurants").document(String(id))
        
        marketDocRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "FirestoreService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])))
                return
            }
            
            if let categoriesData = document.data()?["categories"] as? [[String: Any]] {
                completion(.success(categoriesData))
                self.restIndex += 1
            } else {
                completion(.failure(NSError(domain: "FirestoreService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Categories data not found"])))
            }
        }
    }
}
