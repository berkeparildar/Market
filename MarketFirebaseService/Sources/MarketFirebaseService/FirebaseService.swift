//
//  FirebaseService.swift
//
//
//  Created by Berke Parıldar on 29.10.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

public protocol FirebaseServiceProtocol {
    
}

public class FirebaseService {
    
    public init() {}
    
    private let db = Firestore.firestore()
    
    public func createUser(email: String, password: String,
                           completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let authResult = authResult {
                self.addUserToFirestore(uid: authResult.user.uid, email: email) { firestoreError in
                    if let firestoreError = firestoreError {
                        completion(.failure(firestoreError))
                        return
                    }
                    completion(.success(authResult))
                }
            }
        }
    }
    
    public func signInUser(email: String, password: String,
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
    
    public func checkUserExists(uid: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error getting user document: \(error)")
                completion(error)
            }
            completion(nil)
        }
    }
    
    private func addUserToFirestore(uid: String, email: String,
                                    completion: @escaping (Error?) -> Void) {
        let userData: [String: Any] = [
            "uid": uid,
            "email": email,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            completion(error)
        }
    }
    
    public func fetchUserData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists {
                let userData = document.data()
                completion(.success(userData ?? [:]))
            } else {
                completion(.failure(NSError(domain: "FirebaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }
    
    public func updateUserAddress(uid: String, addressData: [[String: Any?]],
                                  completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(uid)
        
        userRef.updateData(["addresses": addressData]) { error in
            if let error = error {
                print("Error updating user data: \(error.localizedDescription)")
                completion(error)
            } else {
                print("User data successfully updated.")
                completion(nil)
            }
        }
    }
}
