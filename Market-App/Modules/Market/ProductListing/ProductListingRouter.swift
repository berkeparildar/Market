//
//  ProductListingRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 13.11.2024.
//

import UIKit

enum ProductListingRoutes {
    case cart
    case productDetail(product: Product)
    case home
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
        case .productDetail(let product):
            let productDetailView = ProductDetailRouter.createModule(product: product)
            viewController?.navigationController?.pushViewController(productDetailView, animated: true)
        case .cart:
            let cartView = MarketCartRouter.createModule()
            viewController?.navigationController?.pushViewController(cartView, animated: true)
        case .home:
            guard let window = UIApplication.shared.windows.first else { return }
            let homeTabBar = MainTabBarController()
            window.rootViewController = homeTabBar
        }
    }
}

