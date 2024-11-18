//
//  SignInEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 30.10.2024.
//

import Foundation

class User {
    
    var name: String?
    var email: String
    var addresses: [Address] = []
    var phoneNumber: String?
    var verifiedEmail: Bool = false
    
    init(email: String) {
        self.email = email
    }
    
    func updateProperties(from dictionary: [String: Any?]) {
        dictionary.forEach { key, value in
            switch key {
            case "name":
                self.name = value as? String
            case "email":
                self.email = value as? String ?? self.email
            case "addresses":
                self.addresses = value as? [Address] ?? []
            case "phone":
                self.phoneNumber = value as? String
            case "verifiedEmail":
                self.verifiedEmail = value as? Bool ?? false
            default:
                print("Unknown key \(key) - no matching property to update")
            }
        }
    }
}
