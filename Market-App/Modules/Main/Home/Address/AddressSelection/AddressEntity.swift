//
//  AddressEntity.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

class Address {
    let addressText: String
    let latitude: Double
    let longitude: Double
    let floor: String?
    let apartmentNo: String?
    let description: String?
    let title: String?
    let contactName: String?
    let contactSurname: String?
    let contactPhone: String?
  
    
    init(addressText: String,
         latitude: Double,
         longitude: Double,
         floor: String? = nil,
         apartmentNo: String? = nil,
         description: String? = nil,
         title: String? = nil,
         contactName: String? = nil,
         contactSurname: String? = nil,
         contactPhone: String? = nil) {
        
        self.addressText = addressText
        self.latitude = latitude
        self.longitude = longitude
        self.floor = floor
        self.apartmentNo = apartmentNo
        self.description = description
        self.title = title
        self.contactName = contactName
        self.contactSurname = contactSurname
        self.contactPhone = contactPhone
    }
}
