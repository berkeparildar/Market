//
//  PasswordChangePresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

protocol PasswordChangePresenterProtocol: AnyObject {
    func getPasswordEntryCount() -> Int
    func getPasswordEntry(at index: Int) -> PasswordChangeEntity
    func didTapChangePassword()
}

final class PasswordChangePresenter {
    
    let view: PasswordChangeViewControllerProtocol
    let interactor: PasswordChangeInteractorProtocol
    
    private let passwordChangeEntries: [PasswordChangeEntity] = [
        PasswordChangeEntity(label: "Current Password", placeholder: "Enter current password"),
        PasswordChangeEntity(label: "New password", placeholder: "Enter password"),
        PasswordChangeEntity(label: "New password (Again)", placeholder: "Enter password again"),
    ]
    
    init(view: PasswordChangeViewControllerProtocol, interactor: PasswordChangeInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
}

extension PasswordChangePresenter: PasswordChangePresenterProtocol {
    func didTapChangePassword() {
        let oldPassword = passwordChangeEntries[0].password
        let newPassword = passwordChangeEntries[1].password
        let newAgainPassword = passwordChangeEntries[2].password
        guard let oldPassword = oldPassword else {
            view.showMessage(message: "Please enter your current password"){}
            return
        }
        guard let newPassword = newPassword else {
            view.showMessage(message: "Please enter your new password"){}
            return
        }
        guard let newAgainPassword = newAgainPassword else {
            view.showMessage(message: "Please enter your new password again"){}
            return
        }
        
        if newPassword == newAgainPassword {
            interactor.updatePassword(oldPassword: oldPassword, newPassword: newPassword)
        }
        else {
            view.showMessage(message: "New passwords do not match"){}
        }
    }
    
    func getPasswordEntryCount() -> Int {
        return passwordChangeEntries.count
    }
    
    func getPasswordEntry(at index: Int) -> PasswordChangeEntity {
        return passwordChangeEntries[index]
    }
}

extension PasswordChangePresenter: PasswordChangeInteractorOutputProtocol {
    func updatePasswordOutput(error: (any Error)?) {
        if let error = error {
            view.showMessage(message: error.localizedDescription){}
        }
        else {
            view.showMessage(message: "Password changed. Logging out.") { [weak self] in
                guard let self = self else { return }
                view.navigateToLogin()
            }
        }
    }
}
