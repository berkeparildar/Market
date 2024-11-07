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
    func checkSavedLogIn() -> String?
}

protocol SplashInteractorOutputProtocol: AnyObject {
    func internetConnection(status: Bool)
}

final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
}

extension SplashInteractor: SplashInteractorProtocol {
    func checkSavedLogIn() -> String? {
        return UserService.shared.getUserTokenFromKeychain()
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
        self.output?.internetConnection(status: internetStatus)
    }
}
