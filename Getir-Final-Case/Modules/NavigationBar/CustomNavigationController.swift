//
//  CustomNavigationController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 15.04.2024.
//

import UIKit

protocol NavigationBarProtocol: AnyObject {
    func updatePriceInNavigationBar()
    func didTapRightButton()
}

class CustomNavigationController: UINavigationController {
    
    var customNavigationBarView: CustomNavigationBarView?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        rootViewController.navigationItem.hidesBackButton = true
        customNavigationBarView?.hideBackButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
    
    func updatePrice() {
        customNavigationBarView?.updateCartButtonAppearance()
    }
    
    func setTitle(title: String) {
        customNavigationBarView?.navigationTitle.text = title
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count > 1 {
            customNavigationBarView?.addBackButton()
        }
        customNavigationBarView?.addBackButton()
        if viewControllers.last is CartViewController {
            customNavigationBarView?.addTrashButton()
        }
        viewController.navigationItem.hidesBackButton = true
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.last is CartViewController {
            customNavigationBarView?.hideTrashButton()
        }
        super.popViewController(animated: animated)
        if viewControllers.count == 1 {
            customNavigationBarView?.hideBackButton()
        }
        return viewControllers.last
    }
    
    func rightButtonTapped() {
        if let visibleViewController = visibleViewController as? NavigationBarProtocol {
            visibleViewController.didTapRightButton()
        }
    }
}
