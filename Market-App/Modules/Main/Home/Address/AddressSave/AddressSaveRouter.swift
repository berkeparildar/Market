//
//  AddressSaveRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

protocol AddressSaveRouterProtocol {
    func navigateToRoot()
}

final class AddressSaveRouter {
    weak var viewController: AddressSaveViewController?
    
    static func createModule(address: Address) -> AddressSaveViewController {
        
        let view = AddressSaveViewController()
        let interactor = AddressSaveInteractor()
        let router = AddressSaveRouter()
        
        let presenter = AddressSavePresenter(view: view, interactor: interactor, router: router)
        presenter.currentAddress = address
        interactor.output = presenter
        view.presenter = presenter
        router.viewController = view
        return view
    }
}

extension AddressSaveRouter: AddressSaveRouterProtocol {
    func navigateToRoot() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
