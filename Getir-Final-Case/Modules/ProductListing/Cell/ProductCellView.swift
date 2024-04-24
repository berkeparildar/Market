//
//  ProductCellView.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import UIKit
import Kingfisher

protocol ProductCellViewProtocol: AnyObject {
    func setupViews()
    func setupConstraints()
    func configure(product: Product)
    func updateFloatingStepper(product: Product, animated: Bool)
}

final class ProductCellView: UICollectionViewCell {
    
    // This cell's identifier
    static let identifier: String = "productCell"
    
    /* Constraint values representing the floating stepper's current status. */
    private var addSectionHeightAnchor: NSLayoutConstraint!
    private var addSectionShadowHeightAnchor: NSLayoutConstraint!
    
    var presenter: ProductCellPresenter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEWS
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: "OpenSans-SemiBold", size: 12)
        label.textColor = .getirBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.getirLightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-SemiBold", size: 12)
        label.textColor = .getirGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.textColor = .getirPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addSection: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 12)
        label.backgroundColor = .getirPurple
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0"
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    //MARK: -
    
    @objc func addButtonTapped() {
        presenter.didTapAddButton()
    }
    
    @objc func deleteButtonTapped() {
        presenter.didTapRemoveButton()
    }
}

extension ProductCellView: ProductCellViewProtocol {
    
    /* Add subviews to view. */
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
    
    /* Set the constraints according to design */
    func setupConstraints() {
        addSectionHeightAnchor = addSection.heightAnchor.constraint(equalToConstant: 30)
        addSectionShadowHeightAnchor = addSectionShadow.heightAnchor.constraint(equalToConstant: 30)
        
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
    
    /* Configure the cell views according to the Product data*/
    func configure(product: Product) {
        nameLabel.text = product.productName
        attributeLabel.text = product.productDescription
        priceLabel.text = product.productPriceText
        productImage.kf.setImage(with: product.imageURL)
        updateFloatingStepper(product: product, animated: false)
    }
    
    /* Updates the floating stepper's visuals. Sets expanded or not whether product is in the cart.
     Sets the remove button's image according to the count of product.
     For configuration when cell's are being reused, all of this is done with no animation. */
    func updateFloatingStepper(product: Product, animated: Bool) {
        let productCount = product.quantityInCart
        addSectionHeightAnchor.constant = product.isInCart ? 90 : 30
        addSectionShadowHeightAnchor.constant = product.isInCart ? 90 : 30
        let targetColor = product.isInCart ? UIColor.getirPurple.cgColor : UIColor.getirLightGray.cgColor
        let newImage = productCount > 1 ? UIImage(systemName: "minus") : UIImage(systemName: "trash")
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.deleteButton.setImage(newImage, for: .normal)
                self.quantityLabel.text = String(product.quantityInCart)
                self.productImage.layer.borderColor = targetColor
                self.layoutIfNeeded()
            }
        }
        else {
            self.deleteButton.setImage(newImage, for: .normal)
            self.quantityLabel.text = String(product.quantityInCart)
            self.productImage.layer.borderColor = targetColor
        }
    }
    
    
    /* Hit test for add and remove buttons*/
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let addButtonPoint = addButton.convert(point, from: self)
        if addButton.bounds.contains(addButtonPoint) {
            return addButton
        }
        let deleteButtonPoint = deleteButton.convert(point, from: self)
        if deleteButton.bounds.contains(deleteButtonPoint) {
            return deleteButton
        }
        return super.hitTest(point, with: event)
    }
    
}
