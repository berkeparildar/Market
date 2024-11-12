//
//  AddressSaveEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

class AddressSaveEntity {
    let property: String
    let textfieldPlaceholder: String
    var value: String?
    
    init(property: String, textfieldPlaceholder: String, value: String? = nil) {
        self.property = property
        self.textfieldPlaceholder = textfieldPlaceholder
        self.value = value
    }
}
