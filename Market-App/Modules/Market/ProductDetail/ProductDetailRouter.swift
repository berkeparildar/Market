//
//  ProductDetailRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

enum ProductDetailRoutes {
    case cart
}

protocol ProductDetailRouterProtocol {
    func navigate(to route: ProductDetailRoutes)
}

final class ProductDetailRouter {
    private weak var viewController: ProductDetailView?
    
    static func createModule(product: Product) -> ProductDetailView {
        let view = ProductDetailView()
        let interactor = ProductDetailInteractor()
        let router = ProductDetailRouter()
        
        let presenter = ProductDetailPresenter(view: view,
                                               interactor: interactor,
                                               router: router,
                                               product: product)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension ProductDetailRouter: ProductDetailRouterProtocol {
    func navigate(to route: ProductDetailRoutes) {
        switch route {
        case .cart:
            let cartView = MarketCartRouter.createModule()
            viewController?.navigationController?.pushViewController(cartView, animated: true)
            break
        }
    }
}
