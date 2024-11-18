//
//  HomeRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

import UIKit

enum DeliverityRoutes {
    case selectAddress
    case market
    case food
}

protocol DeliverityRouterProtocol {
    func navigate(to route: DeliverityRoutes)
}

final class DeliverityRouter {
    weak var viewController: DeliverityViewController?
    static func createModule() -> DeliverityViewController {
        let view = DeliverityViewController()
        let interactor = DeliverityInteractor()
        let router = DeliverityRouter()
        
        let presenter = DeliverityPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension DeliverityRouter: DeliverityRouterProtocol {
    
    func navigate(to route: DeliverityRoutes) {
        switch route {
        case .selectAddress:
            let addressSelectVC = AddressSelectionRouter.createModule()
            viewController?.navigationController?.pushViewController(addressSelectVC, animated: true)
        case .market:
            guard let window = viewController?.view.window else { return }
            let productListingVC = ProductListingRouter.createModule()
            let marketNavControl = UINavigationController(rootViewController: productListingVC)
            marketNavControl.navigationBar.tintColor = .white
            marketNavControl.navigationBar.backgroundColor = .marketYellow
            marketNavControl.navigationBar.barTintColor = .marketYellow
            marketNavControl.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            window.rootViewController = marketNavControl
            break
        case .food:
            guard let window = viewController?.view.window else { return }
            let foodVC = FoodHomeRouter.createModule()
            let foodNavControl = UINavigationController(rootViewController: foodVC)
            foodNavControl.navigationBar.tintColor = .white
            foodNavControl.navigationBar.backgroundColor = .marketRed
            foodNavControl.navigationBar.barTintColor = .marketRed
            foodNavControl.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            window.rootViewController = foodNavControl
        }
    }
}
