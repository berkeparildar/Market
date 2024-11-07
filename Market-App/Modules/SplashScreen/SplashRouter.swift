//
//  SplashRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.04.2024.
//

import UIKit

enum SplashRoutes {
    case productListing
    case authentication
    case home
}

protocol SplashRouterProtocol: AnyObject {
    func navigate(_ route: SplashRoutes)
}

final class SplashRouter {
    weak var viewController: SplashViewController?
    static func createModule() -> SplashViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let router = SplashRouter()
        
        let presenter = SplashPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension SplashRouter: SplashRouterProtocol {
    func navigate(_ route: SplashRoutes) {
        guard let window = viewController?.view.window else { return }
        switch route {
        case .productListing:
            break
        case .authentication:
            let signInVC = AuthenticationRouter.createModule()
            let navigationController = UINavigationController(rootViewController: signInVC)
            window.rootViewController = navigationController
            break
        case .home:
            let navigationController = HomeTabBarController()
            window.rootViewController = navigationController
            break
        }
    }
}
