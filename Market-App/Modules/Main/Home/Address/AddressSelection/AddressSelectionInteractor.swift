//
//  AddressSelectionInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//

import Foundation

protocol AddressSelectionInteractorProtocol {
    func getSavedAddresses()
    func getCurrentAddressIndex()
    func updateCurrentAddressIndex(index: Int)
    func deleteAddress(at index: Int)
}

protocol AddressSelectionInteractorOutputProtocol: AnyObject {
    func getSavedAddressesOutput(addresses: [Address])
    func getCurrentAddressIndexOutput(index: Int)
    func deleteAddressOutput(error: Error?)
}

final class AddressSelectionInteractor {
    var output: AddressSelectionInteractorOutputProtocol?
}

extension AddressSelectionInteractor: AddressSelectionInteractorProtocol {
    func deleteAddress(at index: Int) {
        UserService.shared.deleteAddress(at: index) { [weak self] error in
            guard let self = self else { return }
            output?.deleteAddressOutput(error: error)
        }
    }
    
    func getSavedAddresses() {
        let user = UserService.shared.getCurrentUser()!
        output?.getSavedAddressesOutput(addresses: user.addresses)
    }
    
    func getCurrentAddressIndex() {
        let currentAddressIndex = UserService.shared.getSavedAddressIndex()
        output?.getCurrentAddressIndexOutput(index: currentAddressIndex)
    }
    
    func updateCurrentAddressIndex(index: Int) {
        UserDefaults.standard.set(index, forKey: "currentAddressIndex")
    }
}
