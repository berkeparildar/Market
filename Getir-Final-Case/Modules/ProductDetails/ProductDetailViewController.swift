//
//  ProductDetailViewController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import UIKit

protocol ProductDetailViewControllerProtocol: AnyObject {
    func setupNavigationBar()
    func setupViews()
    func setupConstraints()
    func setProductImage(imageData: Data)
}

final class ProductDetailViewController: BaseViewController {
    
    var presenter: ProductDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    lazy var productBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        return view
    }()
    
    lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .getirPurple
        label.font = UIFont(name: "OpenSans-Bold", size: 20)
        label.text = "₺0,00"
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .getirBlack
        label.font = UIFont(name: "OpenSans-Bold", size: 16)
        label.text = "Product Name"
        label.textAlignment = .center
        return label
    }()
    
    lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .getirGray
        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
        label.text = "Attribute"
        label.textAlignment = .center
        return label
    }()
    
    lazy var buttonBlock: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .getirPurple
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var buttonTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.backgroundColor = .getirPurple
        label.text = "Sepete Ekle"
        return label
    }()
}

extension ProductDetailViewController: ProductDetailViewControllerProtocol {
    
    func setupViews() {
        view.backgroundColor = .white
        productBlock.addSubview(productImage)
        productBlock.addSubview(priceLabel)
        productBlock.addSubview(nameLabel)
        productBlock.addSubview(attributeLabel)
        view.addSubview(productBlock)
        addToCartButton.addSubview(buttonTextLabel)
        buttonBlock.addSubview(addToCartButton)
        view.addSubview(buttonBlock)
    }
    
    func setupConstraints() {
        [productBlock, productImage, priceLabel, nameLabel, attributeLabel, buttonTextLabel, addToCartButton, buttonBlock].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productBlock.widthAnchor.constraint(equalTo: view.widthAnchor),
            productBlock.topAnchor.constraint(equalTo: view.topAnchor),
            productBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            productImage.widthAnchor.constraint(equalToConstant: 200),
            productImage.heightAnchor.constraint(equalToConstant: 200),
            productImage.topAnchor.constraint(equalTo: productBlock.topAnchor),
            productImage.centerXAnchor.constraint(equalTo: productBlock.centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: productBlock.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: productBlock.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: productBlock.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: productBlock.trailingAnchor, constant: -16),
            
            attributeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            attributeLabel.leadingAnchor.constraint(equalTo: productBlock.leadingAnchor, constant: 16),
            attributeLabel.trailingAnchor.constraint(equalTo: productBlock.trailingAnchor, constant: -16),
            attributeLabel.bottomAnchor.constraint(equalTo: productBlock.bottomAnchor, constant: -16),
            
            buttonBlock.widthAnchor.constraint(equalTo: view.widthAnchor),
            buttonBlock.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addToCartButton.topAnchor.constraint(equalTo: buttonBlock.topAnchor, constant: 16),
            addToCartButton.leadingAnchor.constraint(equalTo: buttonBlock.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: buttonBlock.trailingAnchor, constant: -16),
            addToCartButton.bottomAnchor.constraint(equalTo: buttonBlock.bottomAnchor, constant: -16),
            
            buttonTextLabel.centerXAnchor.constraint(equalTo: addToCartButton.centerXAnchor),
            buttonTextLabel.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            buttonTextLabel.topAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: 15),
            buttonTextLabel.bottomAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: -15)
        ])
    }
    
    func setupNavigationBar() {
        if let customNavController = navigationController as? CustomNavigationController {
            customNavController.setTitle(title: "Ürün Detayı")
        }
    }
    
    func setProductImage(imageData: Data) {
        self.productImage.image = UIImage(data: imageData)
    }
    
}
