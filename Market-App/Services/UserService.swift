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
    
    private let firebaseService: FirebaseService!
    
    private let keychain = Keychain(service: "com.bprldr.Market-App")
    
    static let shared = UserService()
    
    var currentUser: User?
    
    private init() {
        firebaseService = FirebaseService()
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
        firebaseService.signInUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            UserDefaults.standard.set(-1, forKey: "currentAddressIndex")
            switch result {
            case .success(let authDataResult):
                self.saveUserIdToKeychain(uid: authDataResult.user.uid)
                self.fetchUserData { error in
                    completion(error)
                    return
                }
                completion(nil)
                return
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func signUpUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        firebaseService.createUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let authDataResult):
                self.saveUserIdToKeychain(uid: authDataResult.user.uid)
                self.currentUser = User(email: email)
            
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func checkSignInInfo(completion: @escaping (Error?) -> Void) {
        firebaseService.checkUserExists() { error in
            if let error = error {
                completion(error)
            }
            
            self.fetchUserData { error in
                if let error {
                    completion(error)
                }
                
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

    //MARK: - USER DATA OPERATIONS
    func fetchUserData(completion: @escaping (Error?) -> Void) {
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
                        let addressText = address["addressText"] as? String ?? ""
                        let latitude = address["latitude"] as? Double
                        let longitude = address["longitude"] as? Double
                        let floor = address["floor"] as? String ?? ""
                        let apartmentNo = address["apartmentNo"] as? String ?? ""
                        let description = address["description"] as? String ?? ""
                        let title = address["title"] as? String ?? ""
                        let contactName = address["contactName"] as? String ?? ""
                        let contactSurname = address["contactSurname"] as? String ?? ""
                        let contactPhone = address["contactPhone"] as? String ?? ""
                        if let latitude = latitude, let longitude = longitude {
                            let userAddress = Address(addressText: addressText, latitude: latitude, longitude: longitude, floor: floor, apartmentNo: apartmentNo, description: description, title: title, contactName: contactName, contactSurname: contactSurname, contactPhone: contactPhone)
                            currentUser!.addresses.append(userAddress)}
                    }
                }
                
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func updateUserData(name: String?,
                        phoneNumber: String?,
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
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func getSavedAddressIndex() -> Int {
        return UserDefaults.standard.integer(forKey: "currentAddressIndex")
    }
    
    func addAddress(address: Address, completion: @escaping (Error?) -> Void) {
        currentUser!.addresses.append(address)
        let addressData = currentUser!.addresses.map { address in
            return [
                "addressText": address.addressText,
                "latitude": address.latitude,
                "longitude": address.longitude,
                "floor": address.floor ?? "",
                "apartmentNo": address.apartmentNo ?? "",
                "description": address.description ?? "",
                "title": address.title ?? "",
                "contactName": address.contactName ?? "",
                "contactSurname": address.contactSurname ?? "",
                "contactPhone": address.contactPhone ?? ""
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
                "addressText": address.addressText,
                "latitude": address.latitude,
                "longitude": address.longitude,
                "floor": address.floor ?? "",
                "apartmentNo": address.apartmentNo ?? "",
                "description": address.description ?? "",
                "title": address.title ?? "",
                "contactName": address.contactName ?? "",
                "contactSurname": address.contactSurname ?? "",
                "contactPhone": address.contactPhone ?? ""
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
            if currentUser!.addresses.isEmpty {
                UserDefaults.standard.set(-1, forKey: "currentAddressIndex")
            }
            return
        }
    }
    
    // MARK: - AUTHENTICATION DATA UPDATE OPERATIONS
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
