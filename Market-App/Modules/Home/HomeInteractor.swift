//
//  HomeInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

protocol HomeInteractorProtocol {
    
}

protocol HomeInteractorOutput: AnyObject {
    
}

final class HomeInteractor {
    var output: HomeInteractorOutput?
}

extension HomeInteractor: HomeInteractorProtocol {
    
}
