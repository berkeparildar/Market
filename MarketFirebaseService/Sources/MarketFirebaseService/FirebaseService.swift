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
    
    private let userError = NSError(domain: "", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
    
    public func createUser(email: String, password: String,
                           completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(userError))
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let authResult = authResult {
                self.addUserToFirestore(email: email) { firestoreError in
                    if let firestoreError = firestoreError {
                        completion(.failure(firestoreError))
                        return
                    }
                    Auth.auth().currentUser!.sendEmailVerification { _ in }
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
    
    public func checkUserExists(completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(userError)
            return
        }
        completion(nil)
    }
    
    private func addUserToFirestore(email: String,
                                    completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(userError)
            return
        }
        
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": email,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(user.uid).setData(userData) { error in
            completion(error)
        }
    }
    
    public func fetchUserData(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(userError))
            return
        }
        
        db.collection("users").document(user.uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists {
                var userData = document.data()!
                userData["verifiedEmail"] = Auth.auth().currentUser?.isEmailVerified
                if var addresses = userData["addresses"] as? [[String: Any]] {
                    for i in 0..<addresses.count {
                        var address = addresses[i]
                        
                        if let geoPoint = address["geoPoint"] as? GeoPoint {
                            address["latitude"] = geoPoint.latitude
                            address["longitude"] = geoPoint.longitude
                        }
                        
                        addresses[i] = address
                    }
                    
                    userData["addresses"] = addresses
                }
                completion(.success(userData ?? [:]))
            } else {
                completion(.failure(NSError(domain: "FirebaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }
    
    public func updateUserAddress(addressData: [[String: Any?]],
                                  completion: @escaping (Error?) -> Void) {
        
        guard let user = Auth.auth().currentUser else {
            completion(userError)
            return
        }
        
        var geoAddresses = addressData.map { address in
            return [
                "title": address["title"] as? String ?? "",
                "addressText": address["addressText"] as? String ?? "",
                "geoPoint": GeoPoint(latitude: address["latitude"] as? Double ?? 0,
                                        longitude: address["longitude"] as? Double ?? 0)
            ]
        }
        
        let userRef = db.collection("users").document(user.uid)
        
        userRef.updateData(["addresses": geoAddresses]) { error in
            if let error = error {
                print("Error updating user data: \(error.localizedDescription)")
                completion(error)
            } else {
                print("User data successfully updated.")
                completion(nil)
            }
        }
    }
    
    public func updateUserData(userData: [String: Any?], completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(userError)
            return
        }
        
        let userRef = db.collection("users").document(user.uid)
        
        let filteredUserData = userData.compactMapValues { $0 }
        
        userRef.updateData(filteredUserData) { error in
            if let error = error {
                print("Error updating user data: \(error.localizedDescription)")
                completion(error)
            } else {
                print("User data updated successfully")
                completion(nil)
            }
        }
    }
    
    public func changeUserEmail(newEmail: String, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(userError)
            return
        }
        
        user.reload { error in
            if let error = error {
                debugPrint("Error reloading user: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            if !user.isEmailVerified {
                let verificationError = NSError(
                    domain: "",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Please verify your current email before changing to a new one."])
                completion(verificationError)
                return
            }
            
            user.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
                if let error = error {
                    debugPrint("Error updating email: \(error.localizedDescription)")
                    completion(error)
                    return
                }
                else {
                    debugPrint("Verification email sent to \(newEmail)")
                    self.updateUserData(userData: ["email": newEmail]) { error in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    public func changeUserPassword(currentEmail: String,
                                   currentPassword: String,
                                   newPassword: String,
                                   completion: @escaping (Error?) -> Void) {
        
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: currentEmail,
                                                      password: currentPassword)
        
        user?.reauthenticate(with: credential) { result, error in
            if let error = error {
                print("Re-authentication failed: \(error.localizedDescription)")
                completion(error)
            } else {
                user?.updatePassword(to: newPassword) { error in
                    if let error = error {
                        print("Password update failed: \(error.localizedDescription)")
                        completion(error)
                        return
                    } else {
                        print("Password successfully updated")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    public func signOutUser(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

