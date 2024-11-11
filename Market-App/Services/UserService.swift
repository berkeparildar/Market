//
//  UserService.swift
//  Market-App
//
//  Created by Berke Parıldar on 2.11.2024.
//

import MarketFirebaseService
import KeychainAccess
import Foundation
import FirebaseFirestore

final class UserService {
    
    private let firebaseService: FirebaseService!
    private let keychain = Keychain(service: "com.bprldr.Market-App")
    static let shared = UserService()
    var currentUser: User?
    
    private init() {
        firebaseService = FirebaseService()
    }
    
    private func saveUserTokenToKeyChain(token: String) {
        do {
            try keychain.set(token, key: "userToken")
            print("Token saved successfully.")
        } catch let error {
            print("Error saving token to Keychain: \(error)")
        }
    }
    
    func getUserTokenFromKeychain() -> String? {
        do {
            let token = try keychain.get("userToken")
            return token
        } catch let error {
            print("Error getting token from Keychain: \(error)")
        }
        return nil
    }
    
    func checkSignInInfo(completion: @escaping (Bool) -> Void) {
        guard getUserTokenFromKeychain() != nil else {
            completion(false)
            return
        }
        
        firebaseService.checkUserExists() { error in
            if error != nil {
                completion(false)
            }
            self.setCurrentUser { error in
                if let error {
                    print("Error setting current user: \(error)")
                    completion(false)
                }
                completion(true)
                return
            }
        }
    }
    
    func signInUser(email: String, password: String,
                    completion: @escaping (Error?) -> Void) {
        firebaseService.signInUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authDataResult):
                authDataResult.user.getIDToken { token, error in
                    if let error {
                        print("Error getting ID token: \(error)")
                    } else if token != nil {
                        self.saveUserTokenToKeyChain(token: authDataResult.user.uid)
                        self.setCurrentUser { error in
                            if let error {
                                print("Error setting current user: \(error)")
                                completion(error)
                                return
                            }
                            completion(nil)
                            return
                        }
                    }
                }
            case .failure(let error):
                print("Error signing in user: \(error)")
                completion(error)
            }
        }
    }
    
    func signUpUser(email: String, password: String,
                    completion: @escaping (Error?) -> Void) {
        firebaseService.createUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authDataResult):
                authDataResult.user.getIDToken { token, error in
                    if let error {
                        print("Error getting ID token: \(error)")
                    } else if let token {
                        self.saveUserTokenToKeyChain(token: token)
                        self.setCurrentUser { error in
                            if let error {
                                print("Error setting current user: \(error)")
                                completion(error)
                            }
                            completion(nil)
                        }
                        return
                    }
                }
            case .failure(let error):
                print("Error signing in user: \(error)")
                completion(error)
            }
        }
    }
    
    func setCurrentUser(completion: @escaping (Error?) -> Void) {
        firebaseService.fetchUserData() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userData):
                let email = userData["email"] as! String
                currentUser = User(email: email)
                if let name = userData["name"] as? String {
                    currentUser!.name = name
                }
                if let phoneNumber = userData["phone"] as? String {
                    currentUser!.phoneNumber = phoneNumber
                }
                if let verifiedEmail = userData["verifiedEmail"] as? Bool {
                    currentUser!.verifiedEmail = verifiedEmail
                }
                if let addresses = userData["addresses"] as? [[String: Any]] {
                    for address in addresses {
                        let title = address["title"] as? String ?? ""
                        let addressText = address["addressText"] as? String ?? ""
                        let geoPoint = address["geoPoint"] as? GeoPoint
                        if let geoPoint = geoPoint {
                            let userAddress = Address(title: title, addressText: addressText, latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                            currentUser!.addresses.append(userAddress)}
                    }
                }
                completion(nil)
            case .failure(let error):
                print("Error fetching user data: \(error)")
                completion(error)
            }
        }
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func getSavedAddressIndex() -> Int {
        return UserDefaults.standard.integer(forKey: "currentAddressIndex")
    }
    
    func addNewAddress(address: Address, completion: @escaping (Error?) -> Void) {
        currentUser!.addresses.append(address)
        let addressData = currentUser!.addresses.map { address in
            return [
                "title": address.title,
                "addressText": address.addressText,
                "geoPoint": GeoPoint(latitude: address.latitude, longitude: address.longitude)
            ]
        }
        firebaseService.updateUserAddress(addressData: addressData) { [weak self] error in
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
        let address = currentUser!.addresses[index]
        currentUser!.addresses.remove(at: index)
        let addressData = currentUser!.addresses.map { address in
            return [
                "title": address.title,
                "addressText": address.addressText,
                "geoPoint": GeoPoint(latitude: address.latitude, longitude: address.longitude)
            ]
        }
        firebaseService.updateUserAddress(addressData: addressData) { [weak self] error in
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
            return
        }
    }
    
    
    func updateUserInformation(name: String?, phoneNumber: String?,
                               completion: @escaping (Error?) -> Void) {
        let updatedData: [String: Any?] = [
            "name": name,
            "phone": phoneNumber
        ]
        
        let filteredUserData = updatedData.compactMapValues { $0 }
        
        firebaseService.updateUserData(userData: filteredUserData) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
            currentUser!.name = name ?? ""
            currentUser!.phoneNumber = phoneNumber ?? ""
            return
        }
    }
    
    func updateUserEmail(newMail: String, completion: @escaping (Error?) -> Void) {
        firebaseService.changeUserEmail(newEmail: newMail) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            } else {
                currentUser!.email = newMail
                completion(nil)
                return
            }
        }
    }
    
    func signOutUser(completion: @escaping (Error?) -> Void) {
        firebaseService.signOutUser() { [weak self] error in
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
    
    func updateUserPassword(oldPassword: String,
                            newPassword: String,
                            completion: @escaping (Error?) -> Void) {
        
        let email = currentUser!.email
        firebaseService.changeUserPassword(currentEmail: email,
                                           currentPassword: oldPassword,
                                           newPassword: newPassword) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            }
            firebaseService.signOutUser { signOutError in
                if let signOutError = signOutError {
                    completion(signOutError)
                }
                completion(nil)
                return
            }
        }
    }
}
