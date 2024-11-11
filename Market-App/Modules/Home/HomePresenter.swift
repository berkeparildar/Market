//
//  HomePresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

protocol HomePresenterProtocol {
    func didTapMarketButton()
    func didTapFoodButton()
    func didTapAddressButton()
    func setCurrentAddress()
    func updateCurrentAddress()
}
final class HomePresenter: HomePresenterProtocol {
 
    private unowned var view: HomeViewProtocol
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    private var currentAddress: Address?
    
    init(view: HomeViewProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func checkSavedLocation() -> Bool {
        return false
    }
    
    func didTapMarketButton() {
        
    }
    
    func didTapFoodButton() {
        
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

extension HomePresenter: HomeInteractorOutput {
    func checkSavedLocationOutput(result: Bool) {
        if result {
            interactor.getCurrentAddress()
        }
        else {
            view.hideLoadingIndicator()
        }
    }
    
    func getCurrentAddressOutput(address: Address?) {
        currentAddress = address
        view.setAddress(address: currentAddress!)
        view.hideLoadingIndicator()
    }
}
