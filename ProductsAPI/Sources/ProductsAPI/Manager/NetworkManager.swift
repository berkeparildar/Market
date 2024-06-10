//
//  NetworkManager.swift
//
//
//  Created by Berke Parıldar on 24.04.2024.
//

import Foundation
import Moya

public protocol NetworkManagerProtocol {
    func fetchProducts(completion: @escaping (Result<[CategoryAPI], Error>) -> Void)
    func fetchCategories(completion: @escaping (Result<[ProductAPI], Error>) -> Void)
}

public final class NetworkManager {
    
    public init() {}
    
    let provider = MoyaProvider<NetworkService>()
    
    public func fetchCategories(completion: @escaping (Result<[CategoryAPI], Error>) -> Void) {
        provider.request(.getCategories) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let decodedData = try JSONDecoder().decode([CategoryAPI].self, from: moyaResponse.data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchProducts(route: String, completion: @escaping (Result<[ProductAPI], Error>) -> Void) {
        provider.request(.getProducts(categoryName: route)) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let decodedData = try JSONDecoder().decode([ProductAPI].self, from: moyaResponse.data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

