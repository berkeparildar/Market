//
//  LoadingView.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 10.04.2024.
//

import UIKit

/*
 This is the LoadingView that is shown after splash screen, and is shown until the products are fetched in the
 Product Listing page. Product Listing page controlls this view by conforming to LoadingShowable.
 */

protocol LoadingShowable where Self: UIViewController {
    func showLoading()
    func hideLoading()
}

extension LoadingShowable {
    func showLoading() {
        LoadingView.shared.startLoading()
    }
    
    func hideLoading() {
        LoadingView.shared.hideLoading()
    }
}

final class LoadingView {
    
    static let shared = LoadingView()
    
    private var backgroundView: UIView!
    private var logoImage: UIImageView!
    
    
    private init() {
        setupViews()
    }
    
    private func setupViews() {
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = .getirLightGray
        
        logoImage = UIImageView()
        logoImage.image = UIImage(named: "GetirLogo")
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 120),
            logoImage.heightAnchor.constraint(equalToConstant: 120)
        ])
        
    }
    
    private func setupPulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.8
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.2
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        logoImage.layer.add(pulseAnimation, forKey: "pulseAnimation")
    }
    
    func startLoading() {
        setupPulseAnimation()
        UIApplication.shared.windows.first?.addSubview(backgroundView)
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.logoImage.layer.removeAllAnimations()
            self.backgroundView.removeFromSuperview()
        }
    }
}
