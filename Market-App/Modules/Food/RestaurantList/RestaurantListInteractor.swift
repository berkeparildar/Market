//
//  RestaurantListInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

protocol RestaurantListInteractorProtocol: AnyObject {
    func getRestaurants(id: Int)
}

protocol RestaurantListInteractorOutputProtocol: AnyObject {
    func getRestaurantsOutput(result: [Restaurant])
}

final class RestaurantListInteractor {
    var output: RestaurantListInteractorOutputProtocol?
}

extension RestaurantListInteractor: RestaurantListInteractorProtocol {
    func getRestaurants(id: Int) {
        let restaurants = RestaurantService.shared.getRestaurantsById(id: id)
        output?.getRestaurantsOutput(result: restaurants)
    }
}

