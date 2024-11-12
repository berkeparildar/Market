//
//  UserInformationPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

protocol UserInformationPresenterProtocol: AnyObject {
    func getUserData()
    func updateUserInformation()
    func getUserInformationEntityCount() -> Int
    func getUserInformationEntity(at index: Int) -> UserInformationEntity
}

final class UserInformationPresenter {
    
    let interactor: UserInformationInteractorProtocol
    let view: UserInformationViewControllerProtocol
    
    private let userInformationEntities: [UserInformationEntity] = [
        UserInformationEntity(property: "E-mail", isForEmail: true),
        UserInformationEntity(property: "Name",
                              textFieldPlaceHolder: "Enter your name.",
                              isForEmail: false),
        UserInformationEntity(property: "Surname",
                              textFieldPlaceHolder: "Enter your surname.",
                              isForEmail: false),
        UserInformationEntity(property: "Phone",
                              textFieldPlaceHolder: "Enter your phone number.",
                              isForEmail: false)
    ]
    
    private var user: User?
    
    init(interactor: UserInformationInteractorProtocol,
         view: UserInformationViewControllerProtocol) {
        self.interactor = interactor
        self.view = view
    }
}

extension UserInformationPresenter: UserInformationPresenterProtocol {
    func getUserInformationEntityCount() -> Int {
        userInformationEntities.count
    }
    
    func getUserInformationEntity(at index: Int) -> UserInformationEntity {
        return userInformationEntities[index]
    }
    
    func getUserData() {
        interactor.getUserInformation()
    }
    
    func updateUserInformation() {
        guard let name = userInformationEntities[1].value,
              let surname = userInformationEntities[2].value
        else { return }
        guard let phoneNumber = userInformationEntities[3].value else { return }
        
        let fullName = "\(name) \(surname)"
        interactor.updateUserInformation(name: fullName, phoneNumber: phoneNumber)
        
    }
}

extension UserInformationPresenter: UserInformationInteractorOutputProtocol {
    func updateUserInformationOutput(error: (any Error)?) {
        if error != nil {
            view.showResultPrompt(with: "There was a problem updating your data. Please try again.")
        } else {
            view.showResultPrompt(with: "Your data has been updated successfully.")
        }
    }
    
    func setCurrentUser(user: User) {
        userInformationEntities[0].value = user.email
        if let fullUserName = user.name, !fullUserName.isEmpty, fullUserName.contains(" ") {
            if fullUserName.split(separator: " ").count >= 2 {
                let name = fullUserName.split(separator: " ")[0]
                let surname = fullUserName.split(separator: " ")[1]
                userInformationEntities[1].value = String(name)
                userInformationEntities[2].value = String(surname)
            }
        }
        if let phoneNumber = user.phoneNumber {
            userInformationEntities[3].value = phoneNumber
        }
        view.reloadTableView()
    }
}
