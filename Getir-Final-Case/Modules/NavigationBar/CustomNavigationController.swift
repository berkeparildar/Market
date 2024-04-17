//
//  CustomNavigationController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 15.04.2024.
//

import UIKit

protocol UpdateNavigationBarProtocol: AnyObject {
    func updateNavigationBar()
}

class CustomNavigationController: UINavigationController {
    
    var customNavigationBarView: CustomNavigationBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBarView = CustomNavigationBarView()
        customNavigationBarView?.controller = self
        let navigationBar = self.navigationBar
        navigationBar.addSubview(customNavigationBarView!)
        customNavigationBarView!.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .getirPurple
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.barTintColor = UIColor.getirPurple
        }
        
        NSLayoutConstraint.activate([
            customNavigationBarView!.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            customNavigationBarView!.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            customNavigationBarView!.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            customNavigationBarView!.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func updateNavigationBar() {
        customNavigationBarView?.updateCartButtonAppearance()
    }
    
    func setTitle(title: String) {
        customNavigationBarView?.navigationTitle.text = title
        if viewControllers.count > 1 {
            customNavigationBarView?.addBackButton()
        } else {
            customNavigationBarView?.hideBackButton()
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.hidesBackButton = true
    }
}
