//
//  TableCellView.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 18.04.2024.
//

import UIKit

protocol CartCellViewProtocol: AnyObject {
    func setupViews()
    func setupConstraints()
    func updateStepper()
    func configureWithPresenter()
}

class CartCellView: UICollectionViewCell {
    
    // This cell's identifier
    static let identifier = "cartCell"
    
    var presenter: CartCellPresenter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEWS
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 12)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
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
    
    lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 12)
        label.textColor = .getirGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.textColor = .getirPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var buttonSection: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 6
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textSection: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .getirPurple
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .getirLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.tintColor = .getirPurple
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .getirPurple
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
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

extension CartCellView: CartCellViewProtocol {
 
    /* Add subviews to view. */
    func setupViews() {
        baseView.addSubview(productImage)
        textSection.addSubview(nameLabel)
        textSection.addSubview(attributeLabel)
        textSection.addSubview(priceLabel)
        baseView.addSubview(textSection)
        buttonSection.addSubview(deleteButton)
        buttonSection.addSubview(quantityLabel)
        buttonSection.addSubview(addButton)
        baseView.addSubview(buttonSection)
        addSubview(baseView)
        addSubview(seperator)
    }
    
    /* Set the constraints according to design */
    func setupConstraints() {
        NSLayoutConstraint.activate([           
            
            baseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            baseView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            baseView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            
            productImage.widthAnchor.constraint(equalToConstant: 78),
            productImage.heightAnchor.constraint(equalToConstant: 78),
            productImage.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            productImage.topAnchor.constraint(equalTo: baseView.topAnchor),
            productImage.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),

            textSection.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 16),
            textSection.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
            textSection.trailingAnchor.constraint(equalTo: buttonSection.leadingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: textSection.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: textSection.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: textSection.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: attributeLabel.topAnchor, constant: -2),
            
            attributeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            attributeLabel.leadingAnchor.constraint(equalTo: textSection.leadingAnchor),
            attributeLabel.trailingAnchor.constraint(equalTo: textSection.trailingAnchor),
            attributeLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -4),
            
            priceLabel.topAnchor.constraint(equalTo: attributeLabel.bottomAnchor, constant: 4),
            priceLabel.bottomAnchor.constraint(equalTo: textSection.bottomAnchor, constant: -8),
            priceLabel.leadingAnchor.constraint(equalTo: textSection.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: textSection.trailingAnchor),

            
            buttonSection.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
            buttonSection.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            buttonSection.leadingAnchor.constraint(equalTo: textSection.trailingAnchor, constant: 16),
            
            deleteButton.widthAnchor.constraint(equalToConstant: 32),
            deleteButton.heightAnchor.constraint(equalToConstant: 32),
            deleteButton.leadingAnchor.constraint(equalTo: buttonSection.leadingAnchor),
            deleteButton.topAnchor.constraint(equalTo: buttonSection.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: buttonSection.bottomAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor),
            
            quantityLabel.heightAnchor.constraint(equalToConstant: 32),
            quantityLabel.widthAnchor.constraint(equalToConstant: 38),
            quantityLabel.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            quantityLabel.topAnchor.constraint(equalTo: buttonSection.topAnchor),
            quantityLabel.bottomAnchor.constraint(equalTo: buttonSection.bottomAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor),
            
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor),
            addButton.topAnchor.constraint(equalTo: buttonSection.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: buttonSection.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: buttonSection.trailingAnchor),
            
            seperator.heightAnchor.constraint(equalToConstant: 1),
            seperator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            seperator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            seperator.topAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /* Updates the floating stepper's visuals.
     Sets the remove button's image according to the count of product.
     */
    func updateStepper() {
        let productCount = presenter.getProductCount()
        let newImage = productCount > 1 ? UIImage(systemName: "minus") : UIImage(systemName: "trash")
        UIView.animate(withDuration: 0.3) {
            self.deleteButton.setImage(newImage, for: .normal)
            self.quantityLabel.text = String(productCount)
            self.layoutIfNeeded()
        }
    }
    
    /* Configure the cell views according to the Product data*/
    func configureWithPresenter() {
        let product = presenter.getProduct()
        nameLabel.text = product.productName
        attributeLabel.text = product.productDescription
        priceLabel.text = product.productPriceText
        productImage.kf.setImage(with: product.imageURL)
        self.quantityLabel.text = String(product.quantityInCart)
        let newImage = product.quantityInCart > 1 ? UIImage(systemName: "minus") : UIImage(systemName: "trash")
        self.deleteButton.setImage(newImage, for: .normal)
    }
}
