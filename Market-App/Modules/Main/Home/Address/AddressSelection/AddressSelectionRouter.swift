//
//  AddressSelectionRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//
import Foundation

enum AddressSelectionRoutes {
    case addressAdd
}

protocol AddressSelectionRouterProtocol {
    func dismissSelf()
    func navigate(to route: AddressSelectionRoutes)
}

final class AddressSelectionRouter {
    weak var viewController: AddressSelectionViewController?
    
    static func createModule() -> AddressSelectionViewController {
        let view = AddressSelectionViewController()
        let interactor = AddressSelectionInteractor()
        let router = AddressSelectionRouter()
        
        let presenter = AddressSelectionPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension AddressSelectionRouter: AddressSelectionRouterProtocol {
    func navigate(to route: AddressSelectionRoutes) {
        viewController?.navigationController?
            .pushViewController(AddressCreateRouter.createModule(), animated: true)
    }
    
    func dismissSelf() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
