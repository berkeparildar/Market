//
//  PasswordChangeCell.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

import UIKit

class PasswordChangeCell: UITableViewCell, UITextFieldDelegate {
    
    private var entry: PasswordChangeEntity?
    
    static let identifier = "PasswordChangeCell"
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTextField)
        
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(passwordTextField.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX).offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with passwordEntry: PasswordChangeEntity) {
        self.entry = passwordEntry
        passwordLabel.text = passwordEntry.label
        passwordTextField.placeholder = passwordEntry.placeholder
    }
    
    func getPassword() -> String? {
        return passwordTextField.text
    }
    
    @objc private func textFieldDidChange() {
        entry?.password = passwordTextField.text
    }
}
