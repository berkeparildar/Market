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
    
}
