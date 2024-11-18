//
//  HomePresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

protocol DeliverityPresenterProtocol {
    func didTapMarketButton()
    func didTapFoodButton()
    func didTapAddressButton()
    func setCurrentAddress()
    func updateCurrentAddress()
}
final class DeliverityPresenter: DeliverityPresenterProtocol {
 
    private unowned var view: DeliverityViewControllerProtocol
    private let interactor: DeliverityInteractorProtocol
    private let router: DeliverityRouterProtocol
    private var currentAddress: Address?
    private var hasAddress = false
    
    init(view: DeliverityViewControllerProtocol, interactor: DeliverityInteractorProtocol, router: DeliverityRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func checkSavedLocation() -> Bool {
        return false
    }
    
    func didTapMarketButton() {
        if hasAddress {
            router.navigate(to: .market)
        }
        else {
            view.showInfoPopUp(
                message: "Please create an address before continuing.") { [weak self] in
                guard let self = self else { return }
                router.navigate(to: .selectAddress)
            }
        }
    }
    
    func didTapFoodButton() {
        router.navigate(to: .food)
    }
    
    func didTapAddressButton() {
        router.navigate(to: .selectAddress)
    }
    
    func setCurrentAddress(){
        view.showLoadingIndicator()
        interactor.checkSavedLocation()
    }
    
    func updateCurrentAddress() {
        interactor.checkSavedLocation()
    }
}

extension DeliverityPresenter: DeliverityInteractorOutputProtocol {
    func checkSavedLocationOutput(result: Bool) {
        if result {
            interactor.getCurrentAddress()
            hasAddress = true
        }
        else {
            view.hideLoadingIndicator()
            view.setAddress(address: "Select Address")
            hasAddress = false
        }
    }
    
    func getCurrentAddressOutput(address: Address?) {
        currentAddress = address!
        view.setAddress(address: "\(String(describing: address!.title!)) (\(String(describing: address!.addressText)))")
        view.hideLoadingIndicator()
    }
}
