//
//  MarketCartRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

import UIKit

enum MarketCartRoutes {
    case home
    case root
}

protocol MarketCartRouterProtocol {
    func navigate(to route: MarketCartRoutes)
}

final class MarketCartRouter {
    weak var viewController: MarketCartView?
    
    static func createModule() -> MarketCartView {
        let view = MarketCartView()
        let interactor = MarketCartInteractor()
        let router = MarketCartRouter()
        
        let presenter = MarketCartPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension MarketCartRouter: MarketCartRouterProtocol {
    func navigate(to route: MarketCartRoutes) {
        switch route {
        case .home:
            let mainTab = MainTabBarController()
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = mainTab
            break
        case .root:
            viewController?.navigationController?.popToRootViewController(animated: true)
            break
        }
    }
}

