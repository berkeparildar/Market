//
//  MenuRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

import UIKit

enum MenuRoutes {
    case home
}

protocol MenuRouterProtocol {
    func navigate(to route: MenuRoutes)
}

final class MenuRouter {
    weak var viewController: MenuView?
    
    static func createModule(menu: Menu) -> MenuView {
        let view = MenuView()
        let router = MenuRouter()
        
        let presenter = MenuPresenter(view: view, router: router, menu: menu)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
}

extension MenuRouter: MenuRouterProtocol {
    func navigate(to route: MenuRoutes) {
        switch route {
        case .home:
            guard let window = UIApplication.shared.windows.first else { return }
            let homeTabBar = MainTabBarController()
            window.rootViewController = homeTabBar
            break
        }
    }
}
