//
//  UserInformationInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

protocol UserInformationInteractorProtocol: AnyObject {
    func getUserInformation()
    func updateUserInformation(name: String?, phoneNumber: String?)
}

protocol UserInformationInteractorOutputProtocol: AnyObject {
    func setCurrentUser(user: User)
    func updateUserInformationOutput(error: Error?)
}

final class UserInformationInteractor {
    weak var output: UserInformationInteractorOutputProtocol?
}

extension UserInformationInteractor: UserInformationInteractorProtocol {
    func updateUserInformation(name: String?, phoneNumber: String?) {
        UserService.shared.updateUserData(name: name, phoneNumber: phoneNumber) {
            [weak self] error in
            guard let self = self else { return }
            output?.updateUserInformationOutput(error: error)
        }
    }
    
    func getUserInformation() {
        let user = UserService.shared.getCurrentUser()
        guard let user = user else { return }
        output?.setCurrentUser(user: user)
    }
}
