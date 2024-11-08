//
//  SplashInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.04.2024.
//

import Foundation
import Network

protocol SplashInteractorProtocol: AnyObject {
    func checkInternetConnection()
    func checkSavedLogIn()
}

protocol SplashInteractorOutputProtocol: AnyObject {
    func internetConnectionOutput(status: Bool)
    func savedLogInOutput(status: Bool)
}

final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
}

extension SplashInteractor: SplashInteractorProtocol {
    func checkSavedLogIn() {
        UserService.shared.checkSignInInfo { [weak self] result in
            guard let self = self else { return }
            output?.savedLogInOutput(status: result)
        }
    }
    
    func checkInternetConnection() {
        let networkMonitor = NWPathMonitor()
        var internetStatus = true
        networkMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                internetStatus = true
            } else {
                internetStatus = false
            }
        }
        self.output?.internetConnectionOutput(status: internetStatus)
    }
}
