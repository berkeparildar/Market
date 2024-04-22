//
//  ConfirmationDialogue.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 22.04.2024.
//

import UIKit

protocol ConfirmationShowable where Self: UIViewController {
}

extension ConfirmationShowable {
    func showConfitmation(confirm: @escaping () -> Void) {
        ConfirmationDialog.shared.showDialog(confirm: confirm)
    }
}

class ConfirmationDialog {
    static let shared = ConfirmationDialog()
    private var backgroundView: UIView!
    private var dialogView: UIView!
    private var confirmAction: (() -> Void)?
    
    private init() {
        configureViews()
    }
    
    private func configureViews() {
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = .getirGray.withAlphaComponent(0.5)
        
        dialogView = UIView()
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 12
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        dialogView.layer.masksToBounds = true
        
        let messageLabel = UILabel()
        messageLabel.text = "Are you sure you want to empty your cart?"
        messageLabel.font = UIFont(name: "OpenSans-SemiBold", size: 14)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 14)
        confirmButton.layer.cornerRadius = 8
        confirmButton.backgroundColor = .getirPurple
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 14)
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        cancelButton.backgroundColor = .getirGray
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(dialogView)
        dialogView.addSubview(messageLabel)
        dialogView.addSubview(confirmButton)
        dialogView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            dialogView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            dialogView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),

            messageLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -20),
            
            confirmButton.widthAnchor.constraint(equalToConstant: 160),
            confirmButton.heightAnchor.constraint(equalToConstant: 52),
            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: dialogView.centerXAnchor, constant: -5),
            confirmButton.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -10),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 160),
            cancelButton.heightAnchor.constraint(equalToConstant: 52),
            cancelButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            confirmButton.leadingAnchor.constraint(equalTo: dialogView.centerXAnchor, constant: 5),
            confirmButton.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -10),
            cancelButton.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func handleConfirm() {
        dismissDialog()
        confirmAction?()
    }
    
    @objc private func handleCancel() {
        dismissDialog()
    }
    
    func showDialog(confirm: @escaping () -> Void) {
        confirmAction = confirm
        
        if let window = UIApplication.shared.windows.first(where: \.isKeyWindow) {
            window.addSubview(backgroundView)
        }
        
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
        }
    }
    
    private func dismissDialog() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
        }) { _ in
            self.backgroundView.removeFromSuperview()
        }
    }
}
