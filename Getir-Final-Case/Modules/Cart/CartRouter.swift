//
//  CartRouter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 17.04.2024.
//

import Foundation

enum CartRoutes {
    case detail(product: Product)
}

protocol CartRouterProtocol: AnyObject {
    func navigate(_ route: CartRoutes)
}

final class CartRouter {
    
    weak var viewController: CartViewController?
    
    static func createModule(suggestedProducts: [Product]?) -> CartViewController {
        let view = CartViewController()
        let interactor = CartInteractor()
        let router = CartRouter()
        interactor.suggestedProducts = suggestedProducts
        let presenter = CartPresenter(view: view, router: router, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

extension CartRouter: CartRouterProtocol {
    func navigate(_ route: CartRoutes) {
        switch route {
        case .detail(product: let product):
            let productDetailVC = ProductDetailRouter.createModule(product: product)
            viewController?.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
}
