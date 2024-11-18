//
//  FirebaseProductService.swift
//  MarketFirebaseService
//
//  Created by Berke Parıldar on 12.11.2024.
//

import Foundation
import FirebaseFirestore

public class FirebaseProductService {
    
    private let db = Firestore.firestore()
    
    public init() {}
    
    public func fetchCategories(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let marketDocRef = db.collection("markets").document("zBYkIPpgwljus89rMYpB")
        
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
    
}
