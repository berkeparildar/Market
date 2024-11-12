//
//  EmailChangeCell.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

import UIKit

class EmailChangeCell: UITableViewCell, UITextFieldDelegate {
    
    private var entity: EmailChangeEntity?
    
    static let identifier = "EmailChangeCell"
    
    private lazy var leftPropertyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentEmailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftPropertyLabel)
        contentView.addSubview(currentEmailLabel)
        contentView.addSubview(emailTextField)
        
        leftPropertyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(currentEmailLabel.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        }
        
        currentEmailLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX).offset(-16)
            make.centerY.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX).offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with entity: EmailChangeEntity) {
        self.entity = entity
        if entity.isEntityOfCurrentEmail {
            leftPropertyLabel.text = entity.property
            emailTextField.isHidden = true
            currentEmailLabel.text = entity.currentEmail
        }
        else {
            leftPropertyLabel.text = entity.property
            currentEmailLabel.isHidden = true
            emailTextField.placeholder = entity.newEmailTextFieldPlaceholder
        }
    }
    
    @objc private func textFieldDidChange() {
        entity?.newEmail = emailTextField.text
    }
}
