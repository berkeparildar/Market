//
//  ProductDetailRouter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import Foundation

enum ProductDetailRoutes {
    case listing, cart
}

protocol ProductDetailRouterProtocol: AnyObject {
    func navigate(_ route: ProductDetailRoutes)
}

final class ProductDetailRouter {
    
    weak var viewController: ProductDetailViewController?
    
    static func createModule() -> ProductDetailViewController {
        let view = ProductDetailViewController()
        let interactor = ProductDetailInteractor()
        let router = ProductDetailRouter()
        
        let presenter = ProductDetailPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension ProductDetailRouter: ProductDetailRouterProtocol {
    func navigate(_ route: ProductDetailRoutes) {
        
    }
}


