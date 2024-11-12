//
//  AddressSaveInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

protocol AddressSaveInteractorProtocol: AnyObject {
    func saveAddress(address: Address)
}

protocol AddressSaveInteractorOutputProtocol: AnyObject {
    func saveAddressOutput(error: Error?)
}

final class AddressSaveInteractor {
    var output: AddressSaveInteractorOutputProtocol?
}

extension AddressSaveInteractor: AddressSaveInteractorProtocol {
    func saveAddress(address: Address) {
        UserService.shared.addAddress(address: address) { [weak self] error in
            guard let self = self else { return }
            output?.saveAddressOutput(error: error)
        }
    }
}
