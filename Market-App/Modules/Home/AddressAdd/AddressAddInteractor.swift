//
//  AddressAddInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//

protocol AddressAddInteractorProtocol {
    func addNewAddress(addressText: String, adressName: String, latitude: Double, longitude: Double)
}

protocol AddressAddInteractorOutput: AnyObject {
    func addnewAddressOutput(error: Error?)
}

final class AddressAddInteractor {
    var output: AddressAddInteractorOutput?
}

extension AddressAddInteractor: AddressAddInteractorProtocol {
    func addNewAddress(addressText: String, adressName: String, latitude: Double,
                       longitude: Double) {
        let address = Address(title: adressName, addressText: addressText, latitude: latitude,
                              longitude: longitude)
        UserService.shared.addAddress(address: address) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                output?.addnewAddressOutput(error: error)
            }
            else {
                output?.addnewAddressOutput(error: nil)
            }
        }
    }
}
