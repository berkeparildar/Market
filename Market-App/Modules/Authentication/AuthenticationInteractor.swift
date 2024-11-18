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
    func signInResult(error: Error?)
    func signUpResult(error: Error?)
}

final class AuthenticationInteractor {
    var output: AuthenticationInteractorOutputProtocol?
}

extension AuthenticationInteractor: AuthenticationInteractorProtocol {
    func signIn(email: String, password: String) {
        UserService.shared.signInUser(email: email, password: password) { [weak self] error in
            guard let self = self else { return }
            output?.signInResult(error: error)
        }
    }
    
    func signUp(email: String, password: String) {
        UserService.shared.signUpUser(email: email, password: password) { [weak self] error in
            guard let self = self else { return }
            output?.signUpResult(error: error)
        }
    }
}
