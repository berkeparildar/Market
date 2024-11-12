
//
//  EmailChangeBuilder.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

final class EmailChangeBuilder {
    static func createModule() -> EmailChangeViewController {
        let view = EmailChangeViewController()
        let interactor = EmailChangeInteractor()
        
        let presenter = EmailChangePresenter(view: view, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        return view
    }
}
