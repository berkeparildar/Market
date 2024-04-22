//
//  CustomNavigationBarView.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 15.04.2024.
//

import UIKit

class CustomNavigationBarView: UINavigationBar {
    
    var imageBackgroundWidthAnchor: NSLayoutConstraint!
    var imageBackgroundTrailingAnchor: NSLayoutConstraint!
    var controller: UINavigationController?
    
    var updatedPrice: Double = 0.0
        
    lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.backgroundColor = .getirPurple
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Ürünler"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .getirLightGray
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Icon-2")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cartImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.backgroundColor = .getirLightGray
        label.textColor = .getirPurple
        label.textAlignment = .center
        label.text = "₺0,00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var backButton: UIButton = {
        var button = UIButton(type: .system)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var backButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "xMark")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var trashButton: UIButton = {
        var button = UIButton(type: .system)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var trashButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "trash")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupViews()
        setupConstraints()
        updatePrice()
        self.priceLabel.text = String(format: "₺%.2f", self.updatedPrice)
    }
    
    private func setupViews() {
        addSubview(navigationTitle)
        backButton.addSubview(backButtonImage)
        addSubview(backButton)
        trashButton.addSubview(trashButtonImage)
        addSubview(trashButton)
        cartButton.addSubview(priceLabel)
        cartImageBackground.addSubview(cartImage)
        cartButton.addSubview(cartImageBackground)
        addSubview(cartButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        imageBackgroundWidthAnchor = self.cartImageBackground.widthAnchor.constraint(equalToConstant: 34)
        imageBackgroundTrailingAnchor = self.cartImageBackground.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor)
        
        NSLayoutConstraint.activate([
            
            navigationTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            navigationTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            trashButton.widthAnchor.constraint(equalToConstant: 24),
            trashButton.heightAnchor.constraint(equalToConstant: 24),
            trashButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            trashButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            backButtonImage.widthAnchor.constraint(equalToConstant: 12),
            backButtonImage.heightAnchor.constraint(equalToConstant: 12),
            backButtonImage.centerXAnchor.constraint(equalTo: backButton.centerXAnchor),
            backButtonImage.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            trashButtonImage.widthAnchor.constraint(equalToConstant: 18),
            trashButtonImage.heightAnchor.constraint(equalToConstant: 18),
            trashButtonImage.centerXAnchor.constraint(equalTo: trashButton.centerXAnchor),
            trashButtonImage.centerYAnchor.constraint(equalTo: trashButton.centerYAnchor),
            
            cartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            cartButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -5),

            cartImageBackground.leadingAnchor.constraint(equalTo: cartButton.leadingAnchor),
            cartImageBackground.centerYAnchor.constraint(equalTo: cartButton.centerYAnchor),
            cartImageBackground.heightAnchor.constraint(equalToConstant: 34),
            imageBackgroundWidthAnchor,
            
            cartImage.topAnchor.constraint(equalTo: cartImageBackground.topAnchor, constant: 5),
            cartImage.leadingAnchor.constraint(equalTo: cartImageBackground.leadingAnchor, constant: 5),
            cartImage.bottomAnchor.constraint(equalTo: cartImageBackground.bottomAnchor, constant: -5),
            
            priceLabel.leadingAnchor.constraint(equalTo: cartImage.trailingAnchor, constant: 15),
            priceLabel.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: 7),
            priceLabel.bottomAnchor.constraint(equalTo: cartButton.bottomAnchor, constant: -7),
            priceLabel.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: -10)

        ])
    }
    
    private func setupAppearance() {
        self.backgroundColor = .getirPurple
    }
    
    @objc private func cartButtonTapped() {
        if let controller = controller as? CustomNavigationController {
            controller.rightButtonTapped()
        }
    }
    
    @objc private func backButtonTapped() {
        controller?.popViewController(animated: true)
    }
    
    func addBackButton() {
        self.backButton.isHidden = false
    }
    
    func hideBackButton() {
        self.backButton.isHidden = true
    }
    
    func addTrashButton() {
        cartButton.isHidden = true
        trashButton.isHidden = false
    }
    
    func hideTrashButton() {
        trashButton.isHidden = true
        cartButton.isHidden = false
    }
    
    func updateCartButtonAppearance() {
        updatePrice()
        cartButtonAnimationExpand()
    }
    
    func updatePrice() {
        let currentItems = CartService.shared.getProductsInCart()
        var totalPrice = 0.0
        currentItems.forEach {
            totalPrice += $0.productPrice * Double($0.inCartCount)
        }
        self.updatedPrice = totalPrice
    }
    
    func cartButtonAnimationExpand() {
        imageBackgroundWidthAnchor.isActive = false
        imageBackgroundTrailingAnchor.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.priceLabel.text = String(format: "₺%.2f", self.updatedPrice)
            self.cartButtonAnimationContract()
        }
    }
    
    func cartButtonAnimationContract() {
        imageBackgroundTrailingAnchor.isActive = false
        imageBackgroundWidthAnchor.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            // ok
        }
    }
}

