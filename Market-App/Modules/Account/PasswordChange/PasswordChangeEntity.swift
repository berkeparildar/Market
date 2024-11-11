//
//  PasswordChangeEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

class PasswordChangeEntity {
    let label: String
    let placeholder: String
    var password: String?
    
    init(label: String, placeholder: String) {
        self.label = label
        self.placeholder = placeholder
    }
}
