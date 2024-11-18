//
//  RestaurantListPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

protocol RestaurantListPresenterProtocol: AnyObject {
    func didTapRestaurant(index: Int)
    func getRestaurants()
    func getRestaurantCount() -> Int
    func getRestaurantAt(index: Int) -> Restaurant
    func getId() -> Int
}

final class RestaurantListPresenter {
    private unowned var view: RestaurantListViewProtocol!
    private let interactor: RestaurantListInteractorProtocol
    private let router: RestaurantListRouterProtocol
    private let id: Int
    
    init(view: RestaurantListViewProtocol,
         interactor: RestaurantListInteractorProtocol,
         router: RestaurantListRouterProtocol,
         id: Int) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.id = id
    }
    private var restaurants: [Restaurant] = []
}

extension RestaurantListPresenter: RestaurantListPresenterProtocol {
    func getId() -> Int {
        return id
    }
    
    func didTapRestaurant(index: Int) {
        router.navigate(to: .restaurant(restaurant: restaurants[index]))
    }
    
    func getRestaurants() {
        interactor.getRestaurants(id: id)
    }
    
    func getRestaurantCount() -> Int {
        restaurants.count
    }
    
    func getRestaurantAt(index: Int) -> Restaurant {
        restaurants[index]
    }
}

extension RestaurantListPresenter: RestaurantListInteractorOutputProtocol {
    func getRestaurantsOutput(result: [Restaurant]) {
        self.restaurants = result
        view.reloadData()
    }
}
