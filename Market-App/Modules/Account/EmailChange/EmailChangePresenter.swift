//
//  EmailChangePresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

import Foundation

protocol EmailChangePresenterProtocol: AnyObject {
    func getCurrentEmail()
    func updateEmail(newEmail: String)
    func getEmailVerifiedStatus()
}

final class EmailChangePresenter {
    let view: EmailChangeViewControllerProtocol
    let interactor: EmailChangeInteractorProtocol
    
    init(view: EmailChangeViewControllerProtocol, interactor: EmailChangeInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

extension EmailChangePresenter: EmailChangePresenterProtocol {
    func getEmailVerifiedStatus() {
        interactor.getEmailVerifiedStatus()
    }
    
    func updateEmail(newEmail: String) {
        if isValidEmail(newEmail) {
            interactor.updateEmail(email: newEmail)
        }
        else {
            view.showMessage(message: "Please enter a valid e-mail address."){}
        }
    }
    
    func getCurrentEmail() {
        interactor.getEmail()
    }
}

extension EmailChangePresenter: EmailChangeInteractorOutputProtocol {
    func getEmailVerifiedStatusOutput(result: Bool) {
        if !result {
            print("showing message")
            view.showMessage(
                message: "Please verify your e-mail before changing it."){ [weak self] in
                    guard let self = self else { return }
                    view.dismissView()
                }
        }
    }
    
    func updateEmailOutput(error: (any Error)?) {
        if let error = error {
            view.showMessage(message: error.localizedDescription) { [weak self] in
                guard let self = self else { return }
                view.dismissView()
            }
        }
        else {
            view.showMessage(message: "E-mail updated successfully.") { [weak self] in
                guard let self = self else { return }
                view.dismissView()
            }
        }
    }
    
    func getEmailOutput(result: String) {
        view.setCurrentEmail(email: result)
    }
}
