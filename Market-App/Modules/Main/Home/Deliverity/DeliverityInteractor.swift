//
//  HomeInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

protocol DeliverityInteractorProtocol {
    func checkSavedLocation()
    func getCurrentAddress()
}

protocol DeliverityInteractorOutputProtocol: AnyObject {
    func checkSavedLocationOutput(result: Bool)
    func getCurrentAddressOutput(address: Address?)
}

final class DeliverityInteractor {
    var output: DeliverityInteractorOutputProtocol?
}

extension DeliverityInteractor: DeliverityInteractorProtocol {
    
    func getCurrentAddress() {
        let savedAddressIndex = UserService.shared.getSavedAddressIndex()
        let currentUser = UserService.shared.getCurrentUser()!
        if !currentUser.addresses.isEmpty {
            output?.getCurrentAddressOutput(address: currentUser.addresses[savedAddressIndex])
        }
    }
    
    
    
    func checkSavedLocation() {
        let currentUser = UserService.shared.getCurrentUser()
        guard let currentUser = currentUser else {
            output?.checkSavedLocationOutput(result: false)
            return
        }
        if currentUser.addresses.isEmpty {
            output?.checkSavedLocationOutput(result: false)
        }
        else {
            output?.checkSavedLocationOutput(result: true)
        }
    }
}
