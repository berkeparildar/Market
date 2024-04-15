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
    
    lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.backgroundColor = .getirPurple
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Urunler"
        return label
    }()
    
    lazy var cartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .getirLightGray
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var cartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cartImage")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var cartImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.backgroundColor = .getirLightGray
        label.textColor = .getirPurple
        label.textAlignment = .center
        label.text = "₺0,00"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(navigationTitle)
        cartButton.addSubview(priceLabel)
        cartImageBackground.addSubview(cartImage)
        cartButton.addSubview(cartImageBackground)
        addSubview(cartButton)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        [navigationTitle, cartImageBackground, priceLabel, cartImage, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        imageBackgroundWidthAnchor = self.cartImageBackground.widthAnchor.constraint(equalToConstant: 34)
        imageBackgroundTrailingAnchor = self.cartImageBackground.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor)
        
        NSLayoutConstraint.activate([
            
            navigationTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            navigationTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
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
            cartImage.widthAnchor.constraint(equalToConstant: 24),
            
            priceLabel.leadingAnchor.constraint(equalTo: cartImage.trailingAnchor, constant: 15),
            priceLabel.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: 7),
            priceLabel.bottomAnchor.constraint(equalTo: cartButton.bottomAnchor, constant: -7),
            priceLabel.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: -10)

        ])
    }
    
    private func setupAppearance() {
        self.backgroundColor = .getirPurple
    }
    
    @objc private func buttonTapped() {
        // router
    }
    
    func updateCartButtonAppearance() {
        guard let currentItems = CartRepository().fetchCart() else { return }
        var totalPrice = 0.0
        currentItems.forEach {
            if let price = $0.price, let count = $0.count {
                totalPrice += price * Double(count)
            }
        }
        cartButtonAnimationExpand(updatedPrice: totalPrice)
    }
    
    func cartButtonAnimationExpand(updatedPrice: Double) {
        imageBackgroundWidthAnchor.isActive = false
        imageBackgroundTrailingAnchor.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.priceLabel.text = String(format: "₺%.2f", updatedPrice)
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

