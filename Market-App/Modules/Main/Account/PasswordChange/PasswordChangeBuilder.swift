//
//  PasswordChangeBuilder.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

final class PasswordChangeBuilder {
    static func createModule() -> PasswordChangeViewController {
        let view = PasswordChangeViewController()
        let interactor = PasswordChangeInteractor()
        
        let presenter = PasswordChangePresenter(view: view, interactor: interactor)
        
        interactor.output = presenter
        view.presenter = presenter
        
        return view
    }
}
