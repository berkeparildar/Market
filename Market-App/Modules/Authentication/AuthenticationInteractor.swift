//
//  SignInInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 30.10.2024.
//

protocol AuthenticationInteractorProtocol: AnyObject {
    func signIn(email: String, password: String)
    func signUp(email: String, password: String)
}

protocol AuthenticationInteractorOutputProtocol: AnyObject {
    func signInResult(status: Bool)
    func signUpResult(status: Bool)
}

final class AuthenticationInteractor {
    var output: AuthenticationInteractorOutputProtocol?
}

extension AuthenticationInteractor: AuthenticationInteractorProtocol {
    func signIn(email: String, password: String) {
        UserService.shared.signInUser(email: email, password: password) { [weak self] status in
            guard let self = self else { return }
            output?.signInResult(status: status)
        }
    }
    
    func signUp(email: String, password: String) {
        
    }
}
