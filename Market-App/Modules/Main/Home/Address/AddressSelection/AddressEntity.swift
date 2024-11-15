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

    static func from(dictionary: [String: Any]) -> Address? {
        guard
            let addressText = dictionary["addressText"] as? String,
            let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double
        else {
            return nil
        }
        
        return Address(
            addressText: addressText,
            latitude: latitude,
            longitude: longitude,
            floor: dictionary["floor"] as? String,
            apartmentNo: dictionary["apartmentNo"] as? String,
            description: dictionary["description"] as? String,
            title: dictionary["title"] as? String,
            contactName: dictionary["contactName"] as? String,
            contactSurname: dictionary["contactSurname"] as? String,
            contactPhone: dictionary["contactPhone"] as? String
        )
    }
}

extension Address {
    func toDictionary() -> [String: Any] {
        return [
            "addressText": addressText,
            "latitude": latitude,
            "longitude": longitude,
            "floor": floor ?? "",
            "apartmentNo": apartmentNo ?? "",
            "description": description ?? "",
            "title": title ?? "",
            "contactName": contactName ?? "",
            "contactSurname": contactSurname ?? "",
            "contactPhone": contactPhone ?? ""
        ]
    }
}
