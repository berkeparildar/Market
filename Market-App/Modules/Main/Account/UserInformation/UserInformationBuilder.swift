//
//  UserInformationBuilder.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

final class UserInformationBuilder {
    static func createModule() -> UserInformationViewController {
        let view = UserInformationViewController()
        let interactor = UserInformationInteractor()
        
        let presenter = UserInformationPresenter(interactor: interactor, view: view)
        
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
}
