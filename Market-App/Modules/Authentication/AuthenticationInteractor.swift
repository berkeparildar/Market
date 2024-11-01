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
        
    }
    
    func signUp(email: String, password: String) {
        
    }
}
