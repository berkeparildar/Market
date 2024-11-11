//
//  PasswordChangeInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

protocol PasswordChangeInteractorProtocol: AnyObject {
    func updatePassword(oldPassword: String, newPassword: String)
}

protocol PasswordChangeInteractorOutputProtocol: AnyObject {
    func updatePasswordOutput(error: Error?)
}

final class PasswordChangeInteractor {
    var output: PasswordChangeInteractorOutputProtocol?
}

extension PasswordChangeInteractor: PasswordChangeInteractorProtocol {
    func updatePassword(oldPassword: String, newPassword: String) {
        UserService.shared.updateUserPassword(oldPassword: oldPassword,
                                              newPassword: newPassword) { [weak self] error in
            
            guard let self = self else { return }
            self.output?.updatePasswordOutput(error: error)
        }
    }
}
