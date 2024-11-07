//
//  UserService.swift
//  Market-App
//
//  Created by Berke Parıldar on 2.11.2024.
//

import MarketFirebaseService
import KeychainAccess

final class UserService {
    
    private let firebaseService: FirebaseService!
    
    static let shared = UserService()
    
    private init() {
        firebaseService = FirebaseService()
    }
    
    private func saveUserTokenToKeyChain(token: String) {
        let keychain = Keychain(service: "com.bprldr.Market-App")
        do {
            try keychain.set(token, key: "userToken")
            print("Token saved successfully.")
        } catch let error {
            print("Error saving token to Keychain: \(error)")
        }
    }
    
    func getUserTokenFromKeychain() -> String? {
        let keychain = Keychain(service: "com.bprldr.Market-App")
        do {
            let token = try keychain.get("userToken")
            return token
        } catch let error {
            print("Error getting token from Keychain: \(error)")
        }
        return nil
    }
    
    func signInUser(email: String, password: String,
                    completion: @escaping (Bool) -> Void) {
        firebaseService.signInUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authDataResult):
                authDataResult.user.getIDToken { token, error in
                    if let error {
                        print("Error getting ID token: \(error)")
                    } else if let token {
                        self.saveUserTokenToKeyChain(token: token)
                        completion(true)
                        return
                    }
                }
            case .failure(let error):
                print("Error signing in user: \(error)")
                completion(false)
            }
        }
    }
    
    func signUpUser(email: String, password: String,
                    completion: @escaping (Bool) -> Void) {
        firebaseService.createUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authDataResult):
                authDataResult.user.getIDToken { token, error in
                    if let error {
                        print("Error getting ID token: \(error)")
                    } else if let token {
                        self.saveUserTokenToKeyChain(token: token)
                        completion(true)
                        return
                    }
                }
            case .failure(let error):
                print("Error signing in user: \(error)")
                completion(false)
            }
        }
    }
}
