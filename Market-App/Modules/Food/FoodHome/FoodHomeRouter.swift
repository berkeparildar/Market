//
//  FoodHomeRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 16.11.2024.
//

enum FoodHomeRoutes {
    case category(categoryID: Int)
    case restaurant(restaurant: Restaurant)
    case home
}

protocol FoodHomeRouterProtocol: AnyObject {
    func navigate(to route: FoodHomeRoutes)
}

final class FoodHomeRouter {
    weak var viewController: FoodHomeView?
    
    static func createModule() -> FoodHomeView {
        let view = FoodHomeView()
        let interactor = FoodHomeInteractor()
        let router = FoodHomeRouter()
        
        let presenter = FoodHomePresenter(view: view, interactor: interactor, router: router)
        interactor.output = presenter
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
}

extension FoodHomeRouter: FoodHomeRouterProtocol {
    func navigate(to route: FoodHomeRoutes) {
        switch route {
        case .category(let categoryID):
            let categoryVC = RestaurantListRouter.createModule(id: categoryID)
            viewController?.navigationController?.pushViewController(categoryVC, animated: true)
        case .restaurant(restaurant: let restaurant):
            let restaurantVC = RestaurantRouter.createModule(restaurant: restaurant)
            viewController?.navigationController?.pushViewController(restaurantVC, animated: true)
        case .home:
            guard let window = viewController?.view.window else { return }
            let navigationController = MainTabBarController()
            window.rootViewController = navigationController
        }
    }
}

