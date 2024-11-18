//
//  UserService.swift
//  Market-App
//
//  Created by Berke Parıldar on 2.11.2024.
//

import MarketFirebaseService
import KeychainAccess
import Foundation

final class UserService {
    
    private let firebaseUserService: FirebaseUserService!
    private let firebaseAuthService: FirebaseAuthService!
    
    private let userError = NSError(domain: "", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
    
    
    private let keychain = Keychain(service: "com.bprldr.Market-App")
    
    static let shared = UserService()
    
    var currentUser: User?
    
    private init() {
        firebaseUserService = FirebaseUserService()
        firebaseAuthService = FirebaseAuthService()
    }
    
    // MARK: - KEYCHAIN OPERATIONS
    private func saveUserIdToKeychain(uid: String) {
        do {
            try keychain.set(uid, key: "userToken")
            debugPrint("Token saved successfully.")
        } catch let error {
            debugPrint("Error saving token to Keychain: \(error)")
        }
    }
    
    func getUserIdFromKeychain() -> String? {
        do {
            let uid = try keychain.get("userToken")
            return uid
        } catch let error {
            debugPrint("Error getting token from Keychain: \(error)")
        }
        return nil
    }
    
    // MARK: - SIGN IN - SIGN UP - SIGN OUT OPERATIONS
    func signInUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        firebaseAuthService.signInUser(email: email,
                                               password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authDataResult):
                self.saveUserIdToKeychain(uid: authDataResult.user.uid)
                self.fetchUserData { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    completion(nil)
                    return
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func signUpUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        firebaseAuthService.createUser(email: email,
                                               password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authDataResult):
                self.saveUserIdToKeychain(uid: authDataResult.user.uid)
                self.currentUser = User(email: email)
                UserDefaults.standard.set(-1, forKey: "currentAddressIndex")
                completion(nil)
                return
            case .failure(let error):
                completion(error)
                return
            }
        }
    }
    
    func checkSignInInfo(completion: @escaping (Error?) -> Void) {
        firebaseAuthService.checkUserExists() { error in
            if let error = error {
                completion(error)
            }

            
            self.fetchUserData {  [weak self] error in
                guard let self = self else { return }
                if let error {
                    completion(error)
                    return
                }
                currentUser!.verifiedEmail = firebaseAuthService.checkUserEmailVerified()
                completion(nil)
                return
            }
        }
    }
    
    func signOutUser(completion: @escaping (Error?) -> Void) {
        firebaseAuthService.signOutUser() { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            }
            do {
                currentUser = nil
                try keychain.removeAll()
                completion(nil)
                return
            } catch {
                completion(error)
                return
            }
        }
    }
    
    //MARK: - USER DATA OPERATIONS
    func fetchUserData(completion: @escaping (Error?) -> Void) {
        guard let uid = firebaseAuthService.getAuthUser()?.uid else {
            completion(userError);
            return
        }
        firebaseUserService.fetchUserData(uid: uid) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userData):
                let email = userData["email"] as? String ?? ""
                currentUser = User(email: email)
                currentUser?.updateProperties(from: userData)
                currentUser!.verifiedEmail = firebaseAuthService.checkUserEmailVerified()
                
                if let addresses = userData["addresses"] as? [[String: Any]] {
                    if addresses.isEmpty {
                        UserDefaults.standard.set(-1, forKey: "currentAddressIndex")
                    } else {
                        UserDefaults.standard.set(0, forKey: "currentAddressIndex")
                    }
                    currentUser?.addresses = addresses.compactMap { addressDict in
                        return Address.from(dictionary: addressDict)
                    }
                }
                
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func updateUserData(updatedData: [String: Any?],
                        completion: @escaping (Error?) -> Void) {
        guard let uid = firebaseAuthService.getAuthUser()?.uid else {
            completion(userError);
            return
        }
        
        let filteredUserData = updatedData.compactMapValues { $0 }
        
        firebaseUserService.updateUserData(
            uid: uid,
            userData: filteredUserData) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
                currentUser!.updateProperties(from: filteredUserData)
                return
            }
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func getSavedAddressIndex() -> Int {
        return UserDefaults.standard.integer(forKey: "currentAddressIndex")
    }
    
    func addAddress(address: Address, completion: @escaping (Error?) -> Void) {
        guard let uid = firebaseAuthService.getAuthUser()?.uid else {
            completion(userError);
            return
        }
        
        currentUser!.addresses.append(address)
        let addressData = currentUser!.addresses.map { address in
            return address.toDictionary()
        }
        firebaseUserService.updateUserAddress(
            uid: uid,
            addressData: addressData) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    completion(error)
                    currentUser!.addresses.removeLast()
                    return
                }
                completion(nil)
                UserDefaults.standard.set(currentUser!.addresses.count - 1,
                                          forKey: "currentAddressIndex")
                return
            }
    }
    
    func deleteAddress(at index: Int, completion: @escaping (Error?) -> Void) {
        guard let uid = firebaseAuthService.getAuthUser()?.uid else {
            completion(userError);
            return
        }
        
        let address = currentUser!.addresses[index]
        currentUser!.addresses.remove(at: index)
        let addressData = currentUser!.addresses.map { address in
            return address.toDictionary()
        }
        firebaseUserService.updateUserAddress(
            uid: uid,
            addressData: addressData) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    completion(error)
                    currentUser!.addresses.insert(address, at: index)
                    return
                }
                completion(nil)
                let currentSelectedIndex = UserDefaults.standard.integer(forKey: "currentAddressIndex")
                if currentSelectedIndex == index {
                    UserDefaults.standard.set(0, forKey: "currentAddressIndex")
                }
                if currentUser!.addresses.isEmpty {
                    UserDefaults.standard.set(-1, forKey: "currentAddressIndex")
                }
                return
            }
    }
    
    // MARK: - AUTHENTICATION DATA UPDATE OPERATIONS
    func updateUserEmail(newMail: String, completion: @escaping (Error?) -> Void) {
        firebaseAuthService.changeUserEmail(newEmail: newMail) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            } else {
                updateUserData(updatedData: ["email": newMail]) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error {
                        completion(error)
                        return
                    }
                    currentUser!.email = newMail
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func updateUserPassword(oldPassword: String,
                            newPassword: String,
                            completion: @escaping (Error?) -> Void) {
        
        let email = currentUser!.email
        firebaseAuthService.changeUserPassword(currentEmail: email,
                                                       currentPassword: oldPassword,
                                                       newPassword: newPassword) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            }
            firebaseAuthService.signOutUser { signOutError in
                if let signOutError = signOutError {
                    completion(signOutError)
                }
                completion(nil)
                return
            }
        }
    }
}
