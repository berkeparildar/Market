//
//  FoodHomeInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 16.11.2024.
//

protocol FoodHomeInteractorProtocol: AnyObject {
    func getCategories()
    func getRestaurants()
}

protocol FoodHomeInteractorOutputProtocol: AnyObject {
    func getCategoriesOutput(result: [RestaurantCategory])
    func getRestaurantsOutput(result: [Restaurant])
}

final class FoodHomeInteractor {
    var output: FoodHomeInteractorOutputProtocol?
}

extension FoodHomeInteractor: FoodHomeInteractorProtocol {
    func getCategories() {
        RestaurantService.shared.fetchCategories { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching categories: \(error)")
            }
            let categories = RestaurantService.shared.getCategories()
            self.output?.getCategoriesOutput(result: categories)
        }
    }
    
    func getRestaurants() {
        RestaurantService.shared.fetchRestaurants { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching restaurants: \(error)")
            }
            let restaurants = RestaurantService.shared.getRestaurants()
            output?.getRestaurantsOutput(result: restaurants)
        }
    }
}
