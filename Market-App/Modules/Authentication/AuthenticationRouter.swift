//
//  SignInRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 30.10.2024.
//

enum AuthenticationRoutes {
    case home
}

protocol AuthenticationRouterProtocol {
    func navigate(to route: AuthenticationRoutes)
}

final class AuthenticationRouter {
    weak var viewController: AuthenticationViewController?
    static func createModule() -> AuthenticationViewController {
        let view = AuthenticationViewController()
        let interactor = AuthenticationInteractor()
        let router = AuthenticationRouter()
        
        let presenter = AuthenticationPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension AuthenticationRouter: AuthenticationRouterProtocol {
    func navigate(to route: AuthenticationRoutes) {
        print("Navigating to home.")
    }
}
