//
//  FoodHomePresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 16.11.2024.
//

protocol FoodHomePresenterProtocol: AnyObject {
    func didTapCategory(at index: Int)
    func fetchCategories()
    func getCategoryCount() -> Int
    func getCategory(at index: Int) -> RestaurantCategory
    func getRestaurants()
    func getRestaurantCount() -> Int
    func getRestaurant(at index: Int) -> Restaurant
    func didTapRestaurant(at index: Int)
    func backButtonTapped()
}

final class FoodHomePresenter {
    private weak var view: FoodHomeViewProtocol!
    private let interactor: FoodHomeInteractorProtocol
    private let router: FoodHomeRouterProtocol
    
    private var categories: [RestaurantCategory] = []
    private var restaurants: [Restaurant] = []
    
    init(view: FoodHomeViewProtocol,
         interactor: FoodHomeInteractorProtocol,
         router: FoodHomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension FoodHomePresenter: FoodHomePresenterProtocol {
    func backButtonTapped() {
        router.navigate(to: .home)
    }
    
    func didTapRestaurant(at index: Int) {
        router.navigate(to: .restaurant(restaurant: restaurants[index]))
    }
    
    func getRestaurants() {
        interactor.getRestaurants()
    }
    
    func getRestaurantCount() -> Int {
        return restaurants.count
    }
    
    func getRestaurant(at index: Int) -> Restaurant {
        return restaurants[index]
    }
    
    func fetchCategories() {
        interactor.getCategories()
    }
    
    func getCategoryCount() -> Int {
        return categories.count
    }
    
    func getCategory(at index: Int) -> RestaurantCategory {
        return categories[index]
    }
    
    func didTapCategory(at index: Int) {
        router.navigate(to: .category(categoryID: index))
    }
}

extension FoodHomePresenter: FoodHomeInteractorOutputProtocol {
    func getCategoriesOutput(result: [RestaurantCategory]) {
        self.categories = result
        view.reloadData()
    }
    
    func getRestaurantsOutput(result: [Restaurant]) {
        self.restaurants = result
        view.reloadData()
    }
}
