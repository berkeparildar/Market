//
//  SplashPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.04.2024.
//

import Foundation

protocol SplashPresenterProtocol: AnyObject {
    func viewDidAppear()
}

final class SplashPresenter: SplashPresenterProtocol {
    
    unowned var view: SplashViewControllerProtocol!
    let router: SplashRouterProtocol!
    let interactor: SplashInteractorProtocol!
    
    init(view: SplashViewControllerProtocol!, router: SplashRouterProtocol!, interactor: SplashInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidAppear() {
        interactor.checkInternetConnection()
    }
}

extension SplashPresenter: SplashInteractorOutputProtocol {
    
    func internetConnection(status: Bool) {
        if status {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
                guard let self else { return }
                let userToken = interactor.checkSavedLogIn()
                if let userToken = userToken {
                    router.navigate(.home)
                }
                else {
                    router.navigate(.authentication)
                }
            }
        }
        else {
            view.noInternetConnection()
        }
    }
    
}
