//
//  SuccessDialogue.swift
//  Market-App
//
//  Created by Berke Parıldar on 23.04.2024.
//

import UIKit
import SnapKit

protocol InfoPopUpShowable where Self: UIViewController {}

extension InfoPopUpShowable {
    func showInfoPopUp(message: String, confirm: @escaping () -> Void) {
        InfoPopUp.shared.showPopUp(message: message, confirm: confirm)
    }
}

class InfoPopUp {
    static let shared = InfoPopUp()
    
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .marketGray.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        //label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 24
        button.backgroundColor = .marketOrange
        button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var confirmAction: (() -> Void)?
    
    private init() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundView.addSubview(infoView)
        infoView.addSubview(messageLabel)
        infoView.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        setupInfoViewConstraints()
        setupMessageLabelConstraints()
        setupConfirmButtonConstraints()
    }
    
    @objc private func handleConfirm() {
        dismissDialog(animated: true)
        confirmAction?()
    }
    
    func showPopUp(message: String, confirm: @escaping () -> Void) {
        messageLabel.text = message
        confirmAction = confirm
        
        if let window = UIApplication.shared.windows.first(where: \.isKeyWindow) {
            window.addSubview(backgroundView)
            backgroundView.layoutIfNeeded()
        }
        
        infoView.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.backgroundView.layoutIfNeeded()
        }
    }
    
    private func dismissDialog(animated: Bool) {
        infoView.snp.updateConstraints { make in
            make.centerY.equalToSuperview().offset(1000)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            if animated {
                self.backgroundView.layoutIfNeeded()
            }
        }) { _ in
            self.backgroundView.removeFromSuperview()
        }
    }
    
    private func setupInfoViewConstraints() {
        infoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(1000)
        }
    }
    
    private func setupMessageLabelConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupConfirmButtonConstraints() {
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
}

