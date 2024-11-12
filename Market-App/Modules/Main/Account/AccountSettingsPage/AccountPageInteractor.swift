//
//  AccountInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

protocol AccountPageInteractorProtocol {
    func signOut()
}

protocol AccountPageInteractorOutputProtocol {
    func signOutSuccess(error: Error?)
}

final class AccountPageInteractor {
    var output: AccountPageInteractorOutputProtocol?
}

extension AccountPageInteractor: AccountPageInteractorProtocol {
    func signOut() {
        UserService.shared.signOutUser { [weak self] error in
            guard let self = self else { return }
            output?.signOutSuccess(error: error)
        }
    }
}
