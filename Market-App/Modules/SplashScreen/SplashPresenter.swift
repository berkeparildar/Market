//
//  SplashPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.04.2024.
//

import Foundation
import KeychainAccess


protocol SplashPresenterProtocol: AnyObject {
    func viewDidAppear()
}

final class SplashPresenter: SplashPresenterProtocol {
    
    unowned var view: SplashViewControllerProtocol!
    let router: SplashRouterProtocol!
    let interactor: SplashInteractorProtocol!
    
    init(view: SplashViewControllerProtocol!, router: SplashRouterProtocol!, interactor: SplashInteractorProtocol!) {
        /*let keychain = Keychain(service: "com.bprldr.Market-App")
        do {
            try keychain.removeAll()
        } catch {
        }*/
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidAppear() {
        interactor.checkInternetConnection()
    }
}

extension SplashPresenter: SplashInteractorOutputProtocol {
    func savedLogInOutput(error: (any Error)?) {
        if error != nil {
            router.navigate(.authentication)
        } else {
            router.navigate(.home)
        }
    }
    
    func internetConnectionOutput(status: Bool) {
        if status {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else { return }
                interactor.checkSavedLogIn()
            }
        }
        else {
            view.noInternetConnection()
        }
    }
    
}
