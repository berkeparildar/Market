//
//  LoadingView.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 10.04.2024.
//

import UIKit

protocol LoadingViewProtocol where Self: UIViewController {
    func showLoading()
    func hideLoading()
}

extension LoadingViewProtocol {
    func showLoading() {
        LoadingView.shared.startLoading()
    }
    func hideLoading() {
        LoadingView.shared.hideLoading()
    }
}

class LoadingView {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    static let shared = LoadingView()
    var blurView: UIVisualEffectView = UIVisualEffectView()
    
    private init() {
        configure()
    }
    
    func configure() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = UIWindow(frame: UIScreen.main.bounds).frame
        activityIndicator.center = blurView.center
        activityIndicator.hidesWhenStopped = true
        blurView.contentView.addSubview(activityIndicator)
    }
    
    func startLoading() {
        UIApplication.shared.windows.first?.addSubview(blurView)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.blurView.removeFromSuperview()
            self.activityIndicator.stopAnimating()
        }
    }
}
