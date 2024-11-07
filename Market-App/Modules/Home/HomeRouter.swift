//
//  HomeRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

enum HomeRoutes {
        
}

protocol HomeRouterProtocol {
    func navigate(to route: HomeRoutes)
}

final class HomeRouter {
    weak var viewController: HomeViewController?
    static func createModule() -> HomeViewController {
        let view = HomeViewController()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension HomeRouter: HomeRouterProtocol {
    func navigate(to route: HomeRoutes) {
        
    }
}
