//
//  SuggestedCellView.swift
//  Market-App
//
//  Created by Berke Parıldar on 22.04.2024.
//

import UIKit
import Kingfisher

protocol SuggestedCellViewProtocol: AnyObject {
    func configure(product: Product)
    func setupViews()
    func setupConstraints()
}

final class SuggestedCellView: UICollectionViewCell {
    
    // This cell's identifier
    static let identifier: String = "suggestedCell"
    var presenter: SuggestedCellPresenter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEWS
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 12)
        label.textColor = .marketBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.marketLightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .marketGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .marketGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addSection: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addSectionShadow: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.marketBlack.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .marketGreen
        button.backgroundColor = .white
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //MARK: -
    
    @objc func addButtonTapped() {
        presenter.didTapAddButton()
    }

}

extension SuggestedCellView: SuggestedCellViewProtocol {
    
    func setupViews() {
        addSection.addSubview(addButton)
        addSectionShadow.addSubview(addSection)
        addSubview(nameLabel)
        addSubview(attributeLabel)
        addSubview(priceLabel)
        addSubview(productImage)
        addSubview(addSectionShadow)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            productImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            productImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -0),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor, multiplier: 1),
            
            priceLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -0),
            
            attributeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            attributeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            attributeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            attributeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            addSectionShadow.widthAnchor.constraint(equalToConstant: 30),
            addSectionShadow.heightAnchor.constraint(equalToConstant: 30),
            addSectionShadow.trailingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            addSectionShadow.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: -20),
            addSectionShadow.topAnchor.constraint(equalTo: productImage.topAnchor, constant: -10),
            
            addSection.widthAnchor.constraint(equalToConstant: 30),
            addSection.heightAnchor.constraint(equalToConstant: 30),
            addSection.centerXAnchor.constraint(equalTo: addSectionShadow.centerXAnchor),
            addSection.topAnchor.constraint(equalTo: addSectionShadow.topAnchor),
            
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.centerXAnchor.constraint(equalTo: addSection.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: addSection.topAnchor),
            
        ])
    }
    
    func configure(product: Product) {
        nameLabel.text = product.productName
        attributeLabel.text = product.productDescription
        priceLabel.text = product.productPriceText
        productImage.kf.setImage(with: URL(string: product.imageURL))
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let pointForTargetView = addButton.convert(point, from: self)
        if addButton.bounds.contains(pointForTargetView) {
            return addButton
        }
        return super.hitTest(point, with: event)
    }
}
