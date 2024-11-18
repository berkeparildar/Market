//
//  RestaurantPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

import Foundation

protocol RestaurantPresenterProtocol {
    func getMenuGroupCount() -> Int
    func getMenuGroup(at index: Int) -> MenuGroup
    func getMenuCount(in groupIndex: Int) -> Int
    func getMenusOfGroup(index: Int) -> [Menu]
    func getRestaurant() -> Restaurant
    func didSelectMenu(at: IndexPath)
}

final class RestaurantPresenter {
    private unowned var view: RestaurantViewProtocol!
    private let router: RestaurantRouterProtocol
    
    private let restaurant: Restaurant!
    
    init(view: RestaurantViewProtocol,
         router: RestaurantRouterProtocol,
         restaurant: Restaurant  ) {
        self.view = view
        self.router = router
        self.restaurant = restaurant
    }
}

extension RestaurantPresenter: RestaurantPresenterProtocol {
    func didSelectMenu(at: IndexPath) {
        let menu = restaurant.menuGroups[at.section].menus[at.item]
        router.navigate(to: .menu(menu: menu))
    }
    
    func getRestaurant() -> Restaurant {
        return restaurant
    }
    
    func getMenuCount(in groupIndex: Int) -> Int {
        return restaurant.menuGroups[groupIndex].menus.count
    }
    
    func getMenuGroupCount() -> Int {
        return restaurant.menuGroups.count
    }
    
    func getMenuGroup(at index: Int) -> MenuGroup {
        restaurant.menuGroups[index]
    }
    
    func getMenusOfGroup(index: Int) -> [Menu] {
        restaurant.menuGroups[index].menus
    }
}

