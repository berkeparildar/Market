//
//  MenuPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

protocol MenuPresenterProtocol {
    func getMenuOptionCount() -> Int
    func getMenuOption(at index: Int) -> MenuOption
    func getMenu() -> Menu
    func didTapBuyButton()
    func navigateToHome()
}

final class MenuPresenter {
    private unowned var view: MenuViewProtocol!
    private let router: MenuRouterProtocol
    
    private let menu: Menu!
    
    init(view: MenuViewProtocol, router: MenuRouterProtocol, menu: Menu) {
        self.view = view
        self.router = router
        self.menu = menu
        view.setPrice(price: menu.price)
    }
}

extension MenuPresenter: MenuPresenterProtocol {
    func navigateToHome() {
        router.navigate(to: .home)
    }
    
    func didTapBuyButton() {
        for i in 0..<menu.options.count {
            let option = menu.options[i]
            if option.selectedOptionIndex == -1 {
                view.scrollToEmptyOption(option: i)
                return
            }
        }
        view.showCompletedOrder()
    }
    
    func getMenu() -> Menu {
        return menu
    }
    
    func getMenuOption(at index: Int) -> MenuOption {
        return menu.options[index]
    }
    
    func getMenuOptionCount() -> Int {
        return menu.options.count
    }
}

