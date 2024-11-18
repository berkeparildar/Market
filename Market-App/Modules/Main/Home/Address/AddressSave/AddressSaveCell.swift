//
//  AddressSaveCell.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

import UIKit

class AddressSaveCell: UITableViewCell {
    
    private var entity: AddressSaveEntity?
    
    static let identifier = "AddressSaveCell"
    
    private lazy var propertyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(propertyLabel)
        contentView.addSubview(textField)
        
        propertyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(textField.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX).offset(-32)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with addressSaveEntity: AddressSaveEntity) {
        self.entity = addressSaveEntity
        propertyLabel.text = addressSaveEntity.property
        textField.placeholder = addressSaveEntity.textfieldPlaceholder
    }
    
    @objc private func textFieldDidChange() {
        entity?.value = textField.text
    }
}

extension AddressSaveCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

