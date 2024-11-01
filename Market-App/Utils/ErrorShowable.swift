//
//  ShowAlert.swift
//  Market-App
//
//  Created by Berke Parıldar on 22.04.2024.
//

import UIKit

protocol ErrorShowable {
    func showError(title: String, message: String)
}

extension ErrorShowable where Self: UIViewController {
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
