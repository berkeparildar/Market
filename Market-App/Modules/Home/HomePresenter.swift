//
//  HomePresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

protocol HomePresenterProtocol {
    
    
}
final class HomePresenter: HomePresenterProtocol {
    
    private unowned var view: HomeViewProtocol
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    
    init(view: HomeViewProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension HomePresenter: HomeInteractorOutput {
    
}
