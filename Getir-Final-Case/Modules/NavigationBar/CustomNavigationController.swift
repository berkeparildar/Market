//
//  CustomNavigationController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 15.04.2024.
//

import UIKit

protocol RightNavigationButtonDelegate: AnyObject {
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
        setCartButtonVisibility()
        setPriceLabel()
        let navigationBar = self.navigationBar
        navigationBar.addSubview(customNavigationBarView!)
        customNavigationBarView!.translatesAutoresizingMaskIntoConstraints = false
        setupCustomNavigationBarAppearance()
        
        NSLayoutConstraint.activate([
            customNavigationBarView!.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            customNavigationBarView!.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            customNavigationBarView!.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            customNavigationBarView!.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func setupCustomNavigationBarAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .getirPurple
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.barTintColor = UIColor.getirPurple
        }
        
    }
    
    func updatePrice() {
        let updatedPrice = CartService.shared.totalPrice()
        if Int(updatedPrice) == 0 {
            customNavigationBarView?.hideCartButton()
        }
        else {
            customNavigationBarView?.showCartButton()
            customNavigationBarView?.cartButtonAnimation(updatedPrice: updatedPrice)
        }
    }
    
    func setTitle(title: String) {
        customNavigationBarView?.navigationTitle.text = title
    }
    
    func setButtonVisibility() {
        setBackButtonVisibility()
        setTrashButtonVisibility()
        setCartButtonVisibility()
    }
    
    func setBackButtonVisibility() {
        if visibleViewController is ProductListingViewController {
            customNavigationBarView?.hideBackButton()
        } else {
            customNavigationBarView?.addBackButton()
        }
    }
    
    func setTrashButtonVisibility() {
        if visibleViewController is CartViewController {
            customNavigationBarView?.addTrashButton()
        }
        else {
            customNavigationBarView?.hideTrashButton()
        }
    }

    func setCartButtonVisibility() {
        let cartIsEmpty = CartService.shared.isCartEmpty()
        let inCartView = visibleViewController is CartViewController
        if cartIsEmpty || inCartView {
            customNavigationBarView?.cartButtonIsHidden()
        } else {
            customNavigationBarView?.cartButtonIsVisible()
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewController is CartViewController {
            if let cartVC = viewControllers.first(where: { $0 is CartViewController }) {
                popToViewController(cartVC, animated: true)
                return
            }
        }
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.hidesBackButton = true
    }
    
    func setPriceLabel() {
        let totalPrice = CartService.shared.totalPrice()
        customNavigationBarView?.updatePrice(updatedPrice: totalPrice)
    }
    
    func rightButtonTapped() {
        if let visibleViewController = visibleViewController as? RightNavigationButtonDelegate {
            visibleViewController.didTapRightButton()
        }
    }
}
