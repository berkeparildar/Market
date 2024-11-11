//
//  UserInformationEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

class UserInformationEntity {
    let property: String
    var value: String?
    let textFieldPlaceHolder: String?
    var textFieldValue: String?
    let isForEmail: Bool
    
    init(property: String,
         textFieldPlaceHolder: String? = nil,
         textFieldValue: String? = nil,
         value: String? = nil,
         isForEmail: Bool) {
        self.property = property
        self.textFieldPlaceHolder = textFieldPlaceHolder
        self.textFieldValue = textFieldValue
        self.value = value
        self.isForEmail = isForEmail
    }
}

