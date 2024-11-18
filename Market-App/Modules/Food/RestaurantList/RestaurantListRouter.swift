//
//  RestaurantListRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

enum RestaurantListRoutes {
    case restaurant(restaurant: Restaurant)
}

protocol RestaurantListRouterProtocol {
    func navigate(to route: RestaurantListRoutes)
}

final class RestaurantListRouter {
    weak var viewController: RestaurantListView?
    
    static func createModule(id: Int) -> RestaurantListView {
        let view = RestaurantListView()
        let interactor = RestaurantListInteractor()
        let router = RestaurantListRouter()
        
        let presenter = RestaurantListPresenter(view: view, interactor: interactor, router: router, id: id)
        interactor.output = presenter
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
}

extension RestaurantListRouter: RestaurantListRouterProtocol {
    func navigate(to route: RestaurantListRoutes) {
        switch route {
        case .restaurant(restaurant: let restaurant):
            let restaurantVC = RestaurantRouter.createModule(restaurant: restaurant)
            viewController?.navigationController?.pushViewController(restaurantVC, animated: true)
            break
        }
    }
}

