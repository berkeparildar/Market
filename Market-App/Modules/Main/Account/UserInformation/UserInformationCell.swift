//
//  UserInformationCell.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

import UIKit

class UserInformationCell: UITableViewCell, UITextFieldDelegate {
    
    private var entity: UserInformationEntity?
    
    static let identifier = "UserInformationCell"
    
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
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftPropertyLabel)
        contentView.addSubview(currentEmailLabel)
        contentView.addSubview(textField)
        
        leftPropertyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(currentEmailLabel.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        }
        
        currentEmailLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX).offset(-16)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX).offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with entity: UserInformationEntity) {
        self.entity = entity
        if entity.isForEmail {
            leftPropertyLabel.text = entity.property
            textField.isHidden = true
            currentEmailLabel.isHidden = false
            currentEmailLabel.text = entity.value
        }
        else {
            leftPropertyLabel.text = entity.property
            currentEmailLabel.isHidden = true
            textField.isHidden = false
            textField.placeholder = entity.textFieldPlaceHolder
            textField.text = entity.value
        }
    }
    
    @objc private func textFieldDidChange() {
        entity?.value = textField.text
    }
}
