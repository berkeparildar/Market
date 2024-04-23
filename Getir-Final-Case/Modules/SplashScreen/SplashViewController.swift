//
//  SplashViewController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 8.04.2024.
//

import UIKit

protocol SplashViewControllerProtocol: AnyObject {
    func noInternetConnection()
    func setupUI()
}

class SplashViewController: UIViewController {
    
    var presenter: SplashPresenterProtocol?
    
    var background: UIView = {
        var backgroundView = UIView()
        backgroundView.backgroundColor = .getirLightGray
        return backgroundView
    }()
    
    var splashLogo: UIImageView = {
        var logo = UIImageView()
        logo.image = UIImage(named: "GetirLogo")
        logo.tintColor = .systemPurple
        return logo
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidAppear()
        setupUI()
    }
}

extension SplashViewController: SplashViewControllerProtocol {
    
    func setupUI() {
        self.background.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(background)
        splashLogo.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(splashLogo)
        NSLayoutConstraint.activate([
            self.background.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.background.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.background.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.splashLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.splashLogo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.splashLogo.widthAnchor.constraint(equalToConstant: 120),
            self.splashLogo.heightAnchor.constraint(equalToConstant: 120),
 
        ])
        
    }
    
    func noInternetConnection() {
        //showAlert(title: "No Internet Connection", message: "Please try again after")
    }
}
