//
//  AddressAddRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//

enum AddressCreateRoutes {
    case addressList
    case addressSave(address: Address)
}

protocol AddressCreateRouterProtocol {
    func navigate(to route: AddressCreateRoutes)
}

final class AddressCreateRouter {
    weak var viewController: AddressCreateViewController?
    static func createModule() -> AddressCreateViewController {

        let view = AddressCreateViewController()
        let router = AddressCreateRouter()
        
        let presenter = AddressCreatePresenter(view: view, router: router)
        
        view.presenter = presenter
        router.viewController = view
        view.hidesBottomBarWhenPushed = true

        
        return view
    }
}

extension AddressCreateRouter: AddressCreateRouterProtocol {
    func navigate(to route: AddressCreateRoutes) {
        switch route {
        case .addressList:
            viewController?.navigationController?.popViewController(animated: true)
        case .addressSave(let address):
            let addressSaveVC = AddressSaveRouter.createModule(address: address)
            viewController?.navigationController?.pushViewController(addressSaveVC, animated: true)
            break
        }
    }
}
