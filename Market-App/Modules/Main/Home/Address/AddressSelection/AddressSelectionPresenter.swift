//
//  AddressSelectionPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//

protocol AddressSelectionPresenterProtocol {
    func getAddressInfo()
    func didSelectAddress(at index: Int)
    func getAddressAtIndex(index: Int) -> Address
    func getAddressCount() -> Int
    func getCurrentAddressIndex() -> Int
    func didTapAddAddress()
    func deleteAddress(at index: Int)
}

final class AddressSelectionPresenter: AddressSelectionPresenterProtocol {
    
    private var addresses: [Address] = []
    private var currentAddressIndex: Int = 0
    
    private unowned var view: AddressSelectionViewControllerProtocol!
    private let interactor: AddressSelectionInteractorProtocol
    private let router: AddressSelectionRouterProtocol
    
    init(view: AddressSelectionViewControllerProtocol,
         interactor: AddressSelectionInteractorProtocol,
         router: AddressSelectionRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func getAddressInfo() {
        interactor.getSavedAddresses()
        interactor.getCurrentAddressIndex()
    }
    
    func deleteAddress(at index: Int) {
        addresses.remove(at: index)
        interactor.deleteAddress(at: index)
    }
    
    func getAddressAtIndex(index: Int) -> Address {
        return addresses[index]
    }
    
    func getAddressCount() -> Int {
        return addresses.count
    }
    
    func getCurrentAddressIndex() -> Int {
        return currentAddressIndex
    }
    
    func didSelectAddress(at index: Int) {
        interactor.updateCurrentAddressIndex(index: index)
        router.dismissSelf()
    }
    
    func didTapAddAddress() {
        router.navigate(to: .addressAdd)
    }
}

extension AddressSelectionPresenter: AddressSelectionInteractorOutputProtocol {
    func deleteAddressOutput(error: (any Error)?) {
        if let error = error {
            view.showErrorMessage(message:
                                    "There was a problem deleting the address. Please try again.")
            router.dismissSelf()
        }
        else {
            view.reloadTableView()
        }
    }
    
    func getSavedAddressesOutput(addresses: [Address]) {
        self.addresses = addresses
        view.reloadTableView()
    }
    
    func getCurrentAddressIndexOutput(index: Int) {
        self.currentAddressIndex = index
        view.reloadTableView()
    }
}
