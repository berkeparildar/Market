//
//  RestaurantService.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//
import Foundation
import MarketFirebaseService

final class RestaurantService {
    static let shared = RestaurantService()
    
    private let firebaseService: FirebaseFoodService!
    
    init() {
        self.firebaseService = FirebaseFoodService()
    }
    
    var categories: [RestaurantCategory] = []
    var restaurants: [Restaurant] = []
    
    func fetchCategories(completion: @escaping (Error?) -> Void) {
        if !categories.isEmpty {
            completion(nil)
            return
        }
        firebaseService.fetchCategories { result in
            switch result {
            case .success(let categories):
                for category in categories {
                    let fetchedCategory = RestaurantCategory.from(dictionary: category)
                    guard let fetchedCategory = fetchedCategory else { return }
                    self.categories.append(fetchedCategory)
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func fetchRestaurants(completion: @escaping (Error?) -> Void) {
        if !restaurants.isEmpty {
            completion(nil)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var fetchError: Error? = nil
        
        for index in 0...2 {
            dispatchGroup.enter()
            firebaseService.fetchRestaurants(id: index) { result in
                switch result {
                case .success(let restaurants):
                    for restaurant in restaurants {
                        let fetchedRestaurant = Restaurant.from(dictionary: restaurant)
                        guard let fetchedRestaurant = fetchedRestaurant else { continue }
                        self.restaurants.append(fetchedRestaurant)
                    }
                case .failure(let error):
                    fetchError = error
                }
                dispatchGroup.leave()
            }
        }
        
  
        dispatchGroup.notify(queue: .main) {
            completion(fetchError)
        }
    }
    
    
    func getCategories() -> [RestaurantCategory] {
        return categories
    }
    
    func getRestaurants() -> [Restaurant] {
        return restaurants
    }
    
    func getRestaurantsById(id: Int) -> [Restaurant] {
        return restaurants.filter { $0.categories.contains(id) }
    }
}
