//
//  HomeRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

enum DeliverityRoutes {
    case selectAddress
    case market
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
            let productListingVC = ProductListingRouter.createModule()
            viewController?.navigationController?.pushViewController(productListingVC, animated: true)
            break
        }
    }
}
