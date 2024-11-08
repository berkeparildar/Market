//
//  AddressAddRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//

enum AddressAddRoutes {
    case addressList
}

protocol AddressAddRouterProtocol {
    func navigate(to route: AddressAddRoutes)
}

final class AddressAddRouter {
    weak var viewController: AddressAddViewController?
    static func createModule() -> AddressAddViewController {
        
        let view = AddressAddViewController()
        let interactor = AddressAddInteractor()
        let router = AddressAddRouter()
        
        let presenter = AddressAddPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension AddressAddRouter: AddressAddRouterProtocol {
    func navigate(to route: AddressAddRoutes) {
        switch route {
        case .addressList:
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
