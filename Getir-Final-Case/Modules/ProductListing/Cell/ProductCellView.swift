//
//  ProductCellView.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import UIKit

protocol ProductCellViewProtocol: AnyObject {
    func setupViews()
    func setupConstraints()
    func setDeleteButtonImage()
    func setProductImage(imageData: Data)
    func updateQuantityLabel()
    func updateAddSection(isExpanded: Bool)
}

final class ProductCellView: UICollectionViewCell {
    
    var presenter: ProductCellPresenter!
    
    var addSectionHeightAnchor: NSLayoutConstraint!
    var addSectionShadowHeightAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func configureWithPresenter() {
        let product = presenter.product
        presenter.fetchImage()
        nameLabel.text = product.name ?? "Name"
        attributeLabel.text = product.attribute ?? product.shortDescription ?? ""
        priceLabel.text = product.priceText ?? "Price"
        updateQuantityLabel()
        setDeleteButtonImage()
        updateAddSection(isExpanded: presenter.expanded()!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .getirBlack
        return label
    }()
    
    lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.getirLightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .getirGray
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .getirPurple
        return label
    }()
    
    lazy var addSection: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var addSectionShadow: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .getirPurple
        button.backgroundColor = .white
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.tintColor = .getirPurple
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.isHidden = false
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .getirPurple
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0"
        label.isHidden = false
        return label
    }()
    
    @objc func addButtonTapped() {
        presenter.tappedAdd()
    }
    
    @objc func deleteButtonTapped() {
        presenter.tappedRemove()
    }
}

extension ProductCellView: ProductCellViewProtocol {
    
    func setProductImage(imageData: Data) {
        self.productImage.image = UIImage(data: imageData)
    }
    
    func setupViews() {
        addSection.addSubview(deleteButton)
        addSection.addSubview(quantityLabel)
        addSection.addSubview(addButton)
        addSectionShadow.addSubview(addSection)
        addSubview(nameLabel)
        addSubview(attributeLabel)
        addSubview(priceLabel)
        addSubview(productImage)
        addSubview(addSectionShadow)
    }
    
    func setupConstraints() {
        addSectionHeightAnchor = addSection.heightAnchor.constraint(equalToConstant: 30)
        addSectionShadowHeightAnchor = addSectionShadow.heightAnchor.constraint(equalToConstant: 30)
        
        [nameLabel, attributeLabel, priceLabel, productImage, addSection, addSectionShadow, addButton, quantityLabel, deleteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
            addSectionShadowHeightAnchor,
            addSectionShadow.trailingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            addSectionShadow.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: -20),
            addSectionShadow.topAnchor.constraint(equalTo: productImage.topAnchor, constant: -10),
            
            addSection.widthAnchor.constraint(equalToConstant: 30),
            addSectionHeightAnchor,
            addSection.centerXAnchor.constraint(equalTo: addSectionShadow.centerXAnchor),
            addSection.topAnchor.constraint(equalTo: addSectionShadow.topAnchor),
            
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.centerXAnchor.constraint(equalTo: addSection.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: addSection.topAnchor),
            
            quantityLabel.widthAnchor.constraint(equalToConstant: 30),
            quantityLabel.heightAnchor.constraint(equalToConstant: 30),
            quantityLabel.centerXAnchor.constraint(equalTo: addSection.centerXAnchor),
            quantityLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.centerXAnchor.constraint(equalTo: addSection.centerXAnchor),
            deleteButton.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor)
        ])
    }
    
    func setDeleteButtonImage() {
        let productCount = presenter.productCount()!
        if productCount > 1 {
            self.deleteButton.setImage(UIImage(systemName: "minus"), for: .normal)
        }
        else {
            self.deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func updateAddSection(isExpanded: Bool) {
        addSectionHeightAnchor.constant = isExpanded ? 90 : 30
        addSectionShadowHeightAnchor.constant = isExpanded ? 90 : 30
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func updateQuantityLabel() {
        self.quantityLabel.text = String(presenter.productCount() ?? 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) 
    }
}
