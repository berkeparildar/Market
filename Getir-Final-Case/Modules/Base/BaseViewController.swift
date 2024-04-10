//
//  BaseViewController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 8.04.2024.
//

import UIKit

class BaseViewController: UIViewController, LoadingViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
