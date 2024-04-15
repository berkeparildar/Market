//
//  CustomNavigationController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 15.04.2024.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    var customNavigationBarView: CustomNavigationBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBarView = CustomNavigationBarView()
        let navigationBar = self.navigationBar
        navigationBar.addSubview(customNavigationBarView!)
        customNavigationBarView!.translatesAutoresizingMaskIntoConstraints = false
        
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
    
}
