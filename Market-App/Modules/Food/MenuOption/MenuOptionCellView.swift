//
//  MenuOptionCellView.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

import UIKit

class MenuOptionCell: UICollectionViewCell {
    static let identifier = "MenuOptionCell"
    
    private var option: MenuOption!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 2, height: 4)
        contentView.layer.shadowRadius = 3
        setupViews()
        setupConstraints()
    }
    
    private lazy var optionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var optionButton: UIImageView = {
        let button = UIImageView(image: UIImage(systemName: "circle"))
        button.tintColor = .marketRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

// MARK: - VIEW SETUP
extension MenuOptionCell {
    private func setupViews() {
        contentView.addSubview(optionTextLabel)
        contentView.addSubview(optionButton)
    }
    
    private func setupConstraints() {
        setupButtonConstraints()
        setupOptionLabelConstraints()
    }
    
    private func setupButtonConstraints() {
        optionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(optionButton.snp.height)
        }
    }
    
    private func setupOptionLabelConstraints() {
        optionTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(optionButton.snp.trailing).offset(16)
        }
    }
}

// MARK: - CONFUGRATION
extension MenuOptionCell {
    func configure(with menuOption: MenuOption, label: String) {
        self.option = menuOption
        optionTextLabel.text = label
        contentView.backgroundColor = .white
    }
    
    func setSelected() {
        optionButton.image = UIImage(systemName: "circle.fill")
        contentView.backgroundColor = .white
    }
    
    func setNonSelected() {
        optionButton.image = UIImage(systemName: "circle")
        contentView.backgroundColor = .white
    }
    
    func setWarning() {
        contentView.backgroundColor = .marketLightOrange
    }
    
    func resetWarning() {
        contentView.backgroundColor = .white
    }
}
