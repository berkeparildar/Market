//
//  FirebaseAuthService.swift
//  MarketFirebaseService
//
//  Created by Berke Parıldar on 12.11.2024.
//

import FirebaseAuth
import FirebaseFirestore

public class FirebaseAuthService {
        
    private let userError = NSError(domain: "", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
    
    
    public init () {}
    
    public func getAuthUser() -> User? {
        return Auth.auth().currentUser
    }
    
    public func createUser(email: String, password: String,
                           completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        
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
    
    public func checkUserEmailVerified() -> Bool {
        let user = Auth.auth().currentUser
        return user!.isEmailVerified
    }
    
    private func addUserToFirestore(email: String,
                                    completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(userError)
            return
        }
        
        let db = Firestore.firestore()
        
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": email,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(user.uid).setData(userData) { error in
            completion(error)
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
            
            user.sendEmailVerification(beforeUpdatingEmail: newEmail) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    debugPrint("Error updating email: \(error.localizedDescription)")
                    completion(error)
                    return
                }
                else {
                    debugPrint("Verification email sent to \(newEmail)")
                    completion(nil)
                    
                }
            }
        }
    }
}
