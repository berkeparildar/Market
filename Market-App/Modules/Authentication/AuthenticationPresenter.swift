//
//  SignInPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 30.10.2024.
//

import Foundation

protocol AuthenticationPresenterProtocol: AnyObject {
    func didTapSignIn(email: String, password: String)
    func didTapSignUp(email: String, password: String)
}

final class AuthenticationPresenter {
    
    unowned var view: AuthenticationViewControllerProtocol!
    let router: AuthenticationRouterProtocol!
    let interactor: AuthenticationInteractorProtocol!
    
    init(view: AuthenticationViewControllerProtocol!,
         router: AuthenticationRouterProtocol!,
         interactor: AuthenticationInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

extension AuthenticationPresenter: AuthenticationPresenterProtocol {
    func didTapSignIn(email: String, password: String) {
        let emailIsValid = isValidEmail(email)
        if emailIsValid {
            //view.showLoadingIndicator()
            interactor.signIn(email: email, password: password)
        }
        else {
            view.showErrorMessage(message: "Please enter a valid e-mail address")
        }
    }
    
    func didTapSignUp(email: String, password: String) {
        let emailIsValid = isValidEmail(email)
        if emailIsValid {
            //view.showLoadingIndicator()
            interactor.signUp(email: email, password: password)
        }
        else {
            view.showErrorMessage(message: "Please enter a valid e-mail address")
        }
    }
}

extension AuthenticationPresenter: AuthenticationInteractorOutputProtocol {
    func signUpResult(error: Error?) {
        if let error = error {
            view.showErrorMessage(message: error.localizedDescription)
        }
        else {
            view.hideLoadingIndicator()
            print("Sign up success.")
            view.showSuccessMessage { [weak self] in
                guard let self = self else { return }
                router.navigate(to: .home)
            }
        }
    }
    
    func signInResult(error: Error?) {
        if let error = error {
            view.showErrorMessage(message: error.localizedDescription)
        }
        else {
            //view.hideLoadingIndicator()
            print("Sign in success.")
            router.navigate(to: .home)
        }
    }
}
