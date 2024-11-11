//
//  UserInformationViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

import UIKit

protocol UserInformationViewControllerProtocol: AnyObject {
    func updateUserInfo(with user: User)
    func showResultPrompt(with message: String)
}

class UserInformationViewController: UIViewController {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
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
    
    private lazy var surnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Surname"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your surname"
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your phone number"
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
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
        

    var presenter: UserInformationPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.getUserData()
        title = "User Information"
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailLabel)
        view.addSubview(userEmailLabel)
        view.addSubview(surnameLabel)
        view.addSubview(surnameTextField)
        view.addSubview(phoneNumberLabel)
        view.addSubview(phoneNumberTextField)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        setupNameLabelConstraints()
        setupNameTextFieldConstraints()
        setupEmailLabelConstraints()
        setupUserEmailLabelConstraints()
        setupSurnameLabelConstraints()
        setupSurnameTextFieldConstraints()
        setupPhoneNumberLabelConstraints()
        setupPhoneNumberTextFieldConstraints()
        setupSaveButtonConstraints()
    }
    
    @objc private func saveUserInfo() {
        var fullName: String? = nil
        if let name = nameTextField.text, let surname = surnameTextField.text {
            fullName = name + " " + surname
        }
        var phoneNumber = phoneNumberTextField.text
        presenter.didTapSaveButton(name: fullName, phoneNumber: phoneNumber)
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
    }
    
    private func setupNameTextFieldConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.centerX).offset(-16)
        }
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
    
    private func setupSurnameLabelConstraints() {
        surnameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
    }
    
    private func setupSurnameTextFieldConstraints() {
        surnameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.centerX).offset(-16)
        }
    }
    
    private func setupPhoneNumberLabelConstraints() {
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(surnameLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
    }
    
    private func setupPhoneNumberTextFieldConstraints() {
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(surnameLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.centerX).offset(-16)
        }
    }
    
    private func setupSaveButtonConstraints() {
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
    }
}

extension UserInformationViewController: UserInformationViewControllerProtocol, PromptShowable {
    func showResultPrompt(with message: String) {
        showPrompt(message: message) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateUserInfo(with user: User) {
        var name: String? = nil
        var surname: String? = nil
        if let fullName = user.name, fullName.isEmpty == false {
            name = String(fullName.split(separator: " ")[0])
            surname = String(fullName.split(separator: " ")[1])
        }
        nameTextField.text = name ?? ""
        surnameTextField.text = surname ?? ""
        userEmailLabel.text = user.email
        phoneNumberTextField.text = user.phoneNumber ?? ""
    }
}
