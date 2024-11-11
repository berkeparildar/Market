//
//  AccountRouter.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

import UIKit

enum AccountRoutes {
    case userInformation
    case passwordChange
    case emailChange
    case signOut
}

protocol AccountPageRouterProtocol {
    func navigate(to route: AccountRoutes)
}

final class AccountPageRouter {
    weak var viewController: AccountPageViewController?
    static func createModule() -> AccountPageViewController {
        
        let view = AccountPageViewController()
        let interactor = AccountPageInteractor()
        let router = AccountPageRouter()
        
        let presenter = AccountPagePresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension AccountPageRouter: AccountPageRouterProtocol {
    func navigate(to route: AccountRoutes) {
        switch route {
        case .userInformation:
            let userInformationVC = UserInformationBuilder.createModule()
            viewController?.navigationController?.pushViewController(
                userInformationVC, animated: true)
            break
        case .passwordChange:
            let passwordChangeVC = PasswordChangeBuilder.createModule()
            viewController?.navigationController?.pushViewController(
                passwordChangeVC, animated: true)
            break
        case .emailChange:
            let emailChangeVC = EmailChangeBuilder.createModule()
            viewController?.navigationController?.pushViewController(emailChangeVC, animated: true)
            break
        case .signOut:
            UserService.shared.signOutUser { [weak self] error in
                guard let self = self else { return }
                guard let window = viewController?.view.window else { return }
                if let error = error {
                    debugPrint(error)
                    return
                }
                let signInVC = AuthenticationRouter.createModule()
                let navigationController = UINavigationController(rootViewController: signInVC)
                window.rootViewController = navigationController
            }
        }
    }
}
