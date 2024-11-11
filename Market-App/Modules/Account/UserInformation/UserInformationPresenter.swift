//
//  UserInformationPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

protocol UserInformationPresenterProtocol: AnyObject {
    func getUserData()
    func didTapSaveButton(name: String?, phoneNumber: String?)
}

final class UserInformationPresenter {
    
    let interactor: UserInformationInteractorProtocol
    let view: UserInformationViewControllerProtocol
    
    private var user: User?
    
    init(interactor: UserInformationInteractorProtocol,
         view: UserInformationViewControllerProtocol) {
        self.interactor = interactor
        self.view = view
    }
}

extension UserInformationPresenter: UserInformationPresenterProtocol {
    func getUserData() {
        interactor.getUserInformation()
    }
    
    func didTapSaveButton(name: String?, phoneNumber: String?) {
        interactor.updateUserInformation(name: name, phoneNumber: phoneNumber)
    }
}

extension UserInformationPresenter: UserInformationInteractorOutputProtocol {
    func updateUserInformationOutput(error: (any Error)?) {
        if let error = error {
            view.showResultPrompt(with: "There was a problem updating your data. Please try again.")
        } else {
            view.showResultPrompt(with: "Your data has been updated successfully.")
        }
    }
    
    func setCurrentUser(user: User) {
        view.updateUserInfo(with: user)
    }
}
