//
//  HomeInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

protocol HomeInteractorProtocol {
    func checkSavedLocation()
    func getCurrentAddress()
}

protocol HomeInteractorOutput: AnyObject {
    func checkSavedLocationOutput(result: Bool)
    func getCurrentAddressOutput(address: Address?)
}

final class HomeInteractor {
    var output: HomeInteractorOutput?
}

extension HomeInteractor: HomeInteractorProtocol {
    
    func getCurrentAddress() {
        let savedAddressIndex = UserService.shared.getSavedAddressIndex()
        let currentUser = UserService.shared.getCurrentUser()!
        output?.getCurrentAddressOutput(address: currentUser.addresses[savedAddressIndex])
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
        output?.checkSavedLocationOutput(result: true)
    }
}
