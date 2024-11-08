//
//  UserService.swift
//  Market-App
//
//  Created by Berke Parıldar on 2.11.2024.
//

import MarketFirebaseService
import FirebaseFirestore
import KeychainAccess

final class UserService {
    
    private let firebaseService: FirebaseService!
    
    static let shared = UserService()
    var currentUser: User?
    
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
    
    func checkSignInInfo(completion: @escaping (Bool) -> Void) {
        let userToken = getUserTokenFromKeychain()
        if let userToken = userToken {
            firebaseService.checkUserExists(uid: userToken) { error in
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
        else {
            completion(false)
        }
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
                        self.saveUserTokenToKeyChain(token: authDataResult.user.uid)
                        self.setCurrentUser { error in
                            if let error {
                                print("Error setting current user: \(error)")
                                completion(false)
                                return
                            }
                            completion(true)
                            return
                        }
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
                        self.setCurrentUser { error in
                            if let error {
                                print("Error setting current user: \(error)")
                                completion(false)
                            }
                            completion(true)
                        }
                        return
                    }
                }
            case .failure(let error):
                print("Error signing in user: \(error)")
                completion(false)
            }
        }
    }
    
    func setCurrentUser(completion: @escaping (Error?) -> Void) {
        let uid = getUserTokenFromKeychain()
        firebaseService.fetchUserData(uid: uid!) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userData):
                let email = userData["email"] as! String
                currentUser = User(email: email)
                if let name = userData["name"] as? String {
                    currentUser!.name = name
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
        guard let uid = getUserTokenFromKeychain() else { return }
        currentUser!.addresses.append(address)
        let addressData = currentUser!.addresses.map { address in
            return [
                "title": address.title,
                "addressText": address.addressText,
                "geoPoint": GeoPoint(latitude: address.latitude, longitude: address.longitude)
            ]
        }
        firebaseService.updateUserAddress(uid: uid, addressData: addressData) { [weak self] error in
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
        guard let uid = getUserTokenFromKeychain() else { return }
        let address = currentUser!.addresses[index]
        currentUser!.addresses.remove(at: index)
        let addressData = currentUser!.addresses.map { address in
            return [
                "title": address.title,
                "addressText": address.addressText,
                "geoPoint": GeoPoint(latitude: address.latitude, longitude: address.longitude)
            ]
        }
        firebaseService.updateUserAddress(uid: uid, addressData: addressData) { [weak self] error in
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
}
