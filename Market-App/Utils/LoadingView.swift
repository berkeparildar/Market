//
//  LoadingView.swift
//  Market-App
//
//  Created by Berke Parıldar on 10.04.2024.
//

import UIKit

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
        backgroundView.backgroundColor = .marketLightGray
        backgroundView.alpha = 0
        
        logoImage = UIImageView()
        logoImage.image = UIImage(systemName: "cart.circle.fill")
        logoImage.tintColor = .marketGreen
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
        let pulseAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        pulseAnimation.values = [1.0, 1.1, 1.2, 1.1, 1.0]
        pulseAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        pulseAnimation.duration = 1.2
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.repeatCount = Float.infinity
        logoImage.layer.add(pulseAnimation, forKey: "pulseAnimation")
    }
    
    func startLoading() {
        setupPulseAnimation()
        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(backgroundView)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 1
        }, completion: nil)
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.backgroundView.alpha = 0
            }, completion: { _ in
                self.logoImage.layer.removeAllAnimations()
                self.backgroundView.removeFromSuperview()
            })
        }
    }
}
