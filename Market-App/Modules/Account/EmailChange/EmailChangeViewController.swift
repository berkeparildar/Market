//
//  EmailChangeViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

import UIKit

protocol EmailChangeViewControllerProtocol: AnyObject {
    func setCurrentEmail(email: String)
    func showMessage(message: String, action: @escaping () -> Void)
    func dismissView()
}

class EmailChangeViewController: UIViewController {
    
    var presenter: EmailChangePresenterProtocol!
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var newEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "New Email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var newEmailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter new e-mail"
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Save  ", for: .normal)
        button.backgroundColor = .marketOrange
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(saveUserInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Email"
        view.backgroundColor = .white
        presenter.getCurrentEmail()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.getEmailVerifiedStatus()
    }
    
    @objc private func saveUserInfo() {
        presenter.updateEmail(newEmail: newEmailTextField.text ?? "")
    }
    
    private func setupViews() {
        view.addSubview(emailLabel)
        view.addSubview(userEmailLabel)
        view.addSubview(newEmailLabel)
        view.addSubview(newEmailTextField)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        setupUserEmailLabelConstraints()
        setupEmailLabelConstraints()
        setupNewEmailLabelConstraints()
        setupNewEmailTextfieldConstraints()
        setupSaveButtonConstraints()
    }
    
    private func setupEmailLabelConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
    }
    
    private func setupUserEmailLabelConstraints() {
        userEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.snp.centerX).offset(-16)
        }
    }
    
    private func setupNewEmailLabelConstraints() {
        newEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(userEmailLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
    }
    
    private func setupNewEmailTextfieldConstraints() {
        newEmailTextField.snp.makeConstraints { make in
            make.top.equalTo(userEmailLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.centerX).offset(-16)
        }
    }
    
    private func setupSaveButtonConstraints() {
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(newEmailLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
    }
}

extension EmailChangeViewController: EmailChangeViewControllerProtocol, PromptShowable {
    func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    func showMessage(message: String, action: @escaping () -> Void) {
        showPrompt(message: message, confirm: action)
    }
    
    func setCurrentEmail(email: String) {
        userEmailLabel.text = email
    }
}
