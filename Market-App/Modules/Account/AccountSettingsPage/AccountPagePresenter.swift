//
//  AccountPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

protocol AccountPagePresenterProtocol {
    func getAccountSettingsCount() -> Int
    func getAccountSettings(at index: Int) -> AccountPageSettings
    func didSelectSetting(at index: Int)
    func signOut()
}

final class AccountPagePresenter {
    
    private var accountSettings: [AccountPageSettings] = [
        AccountPageSettings(name: "User Information", symbolName: "person.fill",
                            route: .userInformation),
        AccountPageSettings(name: "Change Password", symbolName: "lock.fill",
                            route: .passwordChange),
        AccountPageSettings(name: "Change E-Mail", symbolName: "envelope.fill",
                            route: .emailChange),
        AccountPageSettings(name: "Sign Out", symbolName: "arrow.left.square.fill",
                            route: .signOut),
    ]
    
    let view: AccountPageViewControllerProtocol
    let interactor: AccountPageInteractorProtocol
    let router: AccountPageRouterProtocol
    
    init(view: AccountPageViewControllerProtocol, interactor: AccountPageInteractorProtocol,
         router: AccountPageRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
   
}

extension AccountPagePresenter: AccountPagePresenterProtocol {
    func getAccountSettingsCount() -> Int {
        return accountSettings.count
    }
    
    func getAccountSettings(at index: Int) -> AccountPageSettings {
        return accountSettings[index]
    }
    
    func didSelectSetting(at index: Int) {
        let setting = accountSettings[index]
        router.navigate(to: setting.route)
    }
    
    func signOut() {
        interactor.signOut()
    }
}

extension AccountPagePresenter: AccountPageInteractorOutputProtocol {
    func signOutSuccess(error: (any Error)?) {
        if let error = error {
            view.showErrorInfoPopUp(message: error.localizedDescription)
        }
        router.navigateToLogIn()
    }
}
