//
//  RestaurantRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

enum RestaurantRoutes {
    case menu(menu: Menu)
}

protocol RestaurantRouterProtocol {
    func navigate(to route: RestaurantRoutes)
}

final class RestaurantRouter {
    var viewController: RestaurantView?
    
    static func createModule(restaurant: Restaurant) -> RestaurantView {
        let view = RestaurantView()
        let router = RestaurantRouter()
        
        let presenter = RestaurantPresenter(view: view, router: router, restaurant: restaurant)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
}

extension RestaurantRouter: RestaurantRouterProtocol {
    func navigate(to route: RestaurantRoutes) {
        switch route {
        case .menu(menu: let menu):
            let menuVC = MenuRouter.createModule(menu: menu)
            viewController?.navigationController?.pushViewController(menuVC, animated: true)
        }
    }
}

