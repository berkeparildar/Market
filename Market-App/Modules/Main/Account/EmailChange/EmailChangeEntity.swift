//
//  EmailChangeEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

class EmailChangeEntity {
    let property: String
    var currentEmail: String?
    var newEmailTextFieldPlaceholder: String?
    let isEntityOfCurrentEmail: Bool
    var newEmail: String?
    
    init(label: String,
         emailLabel: String? = nil,
         emailPlaceholder: String? = nil,
         isForOldEmail: Bool) {
        self.property = label
        self.currentEmail = emailLabel
        self.newEmailTextFieldPlaceholder = emailPlaceholder
        self.isEntityOfCurrentEmail = isForOldEmail
    }
}
