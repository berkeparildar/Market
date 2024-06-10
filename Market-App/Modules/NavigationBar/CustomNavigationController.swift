//
//  CustomNavigationController.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.04.2024.
//

import UIKit

protocol RightNavigationButtonDelegate: AnyObject {
    func didTapRightButton()
}

final class CustomNavigationController: UINavigationController {
    
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
            appearance.backgroundColor = .marketGreen
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.barTintColor = UIColor.marketGreen
        }
        
    }
    
    func updatePrice() {
        let updatedPrice = CartService.shared.totalPrice()
        if updatedPrice == 0.0 {
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
    
    // Sets the back button's visibility, if at home page do not show
    func setBackButtonVisibility() {
        if visibleViewController is ProductListingViewController {
            customNavigationBarView?.hideBackButton()
        } else {
            customNavigationBarView?.addBackButton()
        }
    }
    
    // Sets the trash button's visibility, if at cart page show
    func setTrashButtonVisibility() {
        if visibleViewController is CartViewController {
            customNavigationBarView?.addTrashButton()
        }
        else {
            customNavigationBarView?.hideTrashButton()
        }
    }

    // Sets the cart button's visibility, if there are no products, or at cart, do not show
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
            // Since you can navigate to product detail from cart, instead of creating a new route to cart from product detail,
            // pop back to cart
            if let cartVC = viewControllers.first(where: { $0 is CartViewController }) {
                popToViewController(cartVC, animated: true)
                return
            }
        }
        super.pushViewController(viewController, animated: animated)
        // hide back button since we use custom
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
