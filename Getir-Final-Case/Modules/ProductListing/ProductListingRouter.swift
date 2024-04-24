//
//  ProductListingRouter.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import UIKit

/*
 Routing module for the Product Listing page, with the only two available routes being Product Detail and the Cart.
 Passes the Product to the Product Detail, and the SuggestedProducts array to the cart. 
 */

enum ProductListingRoutes {
    case detail(product: Product),
         cart(suggestedProducts: [Product])
}

protocol ProductListingRouterProtocol: AnyObject {
    func navigate(_ route: ProductListingRoutes)
}

final class ProductListingRouter {
    
    weak var viewController: ProductListingViewController?
    
    static func createModule() -> ProductListingViewController {
        let view = ProductListingViewController()
        let interactor = ProductListingInteractor()
        let router = ProductListingRouter()
        
        let presenter = ProductListingPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
}

extension ProductListingRouter: ProductListingRouterProtocol {
    
    func navigate(_ route: ProductListingRoutes) {
        switch route {
        case .detail(product: let product):
            let productDetailVC = ProductDetailRouter.createModule(product: product)
            viewController?.navigationController?.pushViewController(productDetailVC, animated: true)
        case .cart(suggestedProducts: let products):
            let cartVC = CartRouter.createModule(suggestedProducts: products)
            viewController?.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
    
}

