//
//  ProductListingRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 13.11.2024.
//

enum ProductListingRoutes {
    case cart
}

protocol ProductListingRouterProtocol {
    func navigate(to route: ProductListingRoutes)
}

final class ProductListingRouter {
    var viewController: ProductListingViewController?
    
    static func createModule() -> ProductListingViewController {
        let view = ProductListingViewController()
        let interactor = ProductListingInteractor()
        let router = ProductListingRouter()
        let presenter = ProductListingPresenter(view: view, interactor: interactor, router: router)
        view.hidesBottomBarWhenPushed = true
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension ProductListingRouter: ProductListingRouterProtocol {
    func navigate(to route: ProductListingRoutes) {
        switch route {
        case .cart:
            break
        }
    }
}

