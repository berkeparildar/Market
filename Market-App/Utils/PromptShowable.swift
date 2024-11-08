//
//  SuccessDialogue.swift
//  Market-App
//
//  Created by Berke Parıldar on 23.04.2024.
//

import UIKit

protocol PromptShowable where Self: UIViewController {}

extension PromptShowable {
    func showPrompt(message: String, confirm: @escaping () -> Void) {
        PromptDialogue.shared.showDialog(message: message, confirm: confirm)
    }
}

class PromptDialogue {
    static let shared = PromptDialogue()
    private var backgroundView: UIView!
    private var dialogView: UIView!
    private var confirmAction: (() -> Void)?
    private var messageLabel: UILabel!
    private var showingConstraint: NSLayoutConstraint!
    private var hidingConstraint: NSLayoutConstraint!
    
    private init() {
        configureViews()
    }
    
    private func configureViews() {
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = .marketGray.withAlphaComponent(0.5)
        
        dialogView = UIView()
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 12
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        dialogView.layer.masksToBounds = true
        
        messageLabel = UILabel()
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .marketBlack
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Ok", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        confirmButton.layer.cornerRadius = 8
        confirmButton.backgroundColor = .marketOrange
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(dialogView)
        dialogView.addSubview(messageLabel)
        dialogView.addSubview(confirmButton)
        
        showingConstraint = dialogView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        hidingConstraint = dialogView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 320)
        
        NSLayoutConstraint.activate([
            dialogView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            dialogView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            dialogView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            hidingConstraint,

            messageLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor),
        
            confirmButton.heightAnchor.constraint(equalToConstant: 48),
            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            confirmButton.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -10),
            confirmButton.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 10),
            confirmButton.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -10),
        ])
    }
    
    @objc private func handleConfirm() {
        dismissDialog(animated: true)
        confirmAction?()
    }
    
    func showDialog(message: String, confirm: @escaping () -> Void) {
        messageLabel.text = message
        confirmAction = confirm
        
        if let window = UIApplication.shared.windows.first(where: \.isKeyWindow) {
            window.addSubview(backgroundView)
            backgroundView.layoutIfNeeded()
        }
        
        hidingConstraint.isActive = false
        showingConstraint.isActive = true
        
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.backgroundView.layoutIfNeeded()
        }
    }
    
    private func dismissDialog(animated: Bool) {
        showingConstraint.isActive = false
        hidingConstraint.isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            if animated {
                self.backgroundView.layoutIfNeeded()
            }
        }) { _ in
            self.backgroundView.removeFromSuperview()
        }
    }
}

