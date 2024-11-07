//
//  HomeTabBarController.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeRouter.createModule()
        //let secondViewController = SecondViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        //secondViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        
        viewControllers = [homeVC]

        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5))
        topBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3) // Matches default color
        tabBar.addSubview(topBorder)
        tabBar.tintColor = .marketOrange
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
    }
}
