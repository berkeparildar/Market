//
//  FirebaseService.swift
//
//
//  Created by Berke Parıldar on 29.10.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

public protocol FirebaseServiceProtocol {
    
}

public final class FirebaseService {
    
    private init() {}
    
    public static let shared = FirebaseService()
    
    public func initializeFirebase() {
        FirebaseApp.configure()
    }
    
    func createUser(email: String, password: String,
                    completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    func signInUser(email: String, password: String,
                    completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }

}
