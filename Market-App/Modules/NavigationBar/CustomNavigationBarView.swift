//
//  CustomNavigationBarView.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.04.2024.
//

import UIKit

class CustomNavigationBarView: UINavigationBar {
    
    var imageBackgroundWidthAnchor: NSLayoutConstraint!
    var imageBackgroundTrailingAnchor: NSLayoutConstraint!
    var buttonShowingTrailingAnchor: NSLayoutConstraint!
    var buttonHidingTrailingAnchor: NSLayoutConstraint!
    var controller: UINavigationController?
            
    lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.backgroundColor = .marketGreen
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Products"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .marketLightGray
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart.fill")
        imageView.tintColor = .marketGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    lazy var cartImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.backgroundColor = .marketLightGray
        label.textColor = .marketGreen
        label.textAlignment = .center
        label.text = "$0,00"
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
        imageView.image = UIImage(systemName: "xmark")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var trashButton: UIButton = {
        var button = UIButton(type: .system)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var trashButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "trash.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupViews()
        setupConstraints()
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
        
        buttonShowingTrailingAnchor = cartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        buttonHidingTrailingAnchor = cartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 120)
        
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
            
            backButtonImage.widthAnchor.constraint(equalToConstant: 20),
            backButtonImage.heightAnchor.constraint(equalToConstant: 20),
            backButtonImage.centerXAnchor.constraint(equalTo: backButton.centerXAnchor),
            backButtonImage.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            trashButtonImage.widthAnchor.constraint(equalToConstant: 20),
            trashButtonImage.heightAnchor.constraint(equalToConstant: 20),
            trashButtonImage.centerXAnchor.constraint(equalTo: trashButton.centerXAnchor),
            trashButtonImage.centerYAnchor.constraint(equalTo: trashButton.centerYAnchor),
            
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
        self.backgroundColor = .marketGreen
    }
    
    func updatePrice(updatedPrice: Double) {
        self.priceLabel.text = String(format: "$%.2f", updatedPrice)
    }
    
    @objc private func rightButtonTapped() {
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
    
    func hideCartButton() {
        buttonShowingTrailingAnchor.isActive = false
        buttonHidingTrailingAnchor.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.cartButton.isHidden = true
        }
    }
    
    func showCartButton() {
        if cartButton.isHidden {
            cartButton.isHidden = false
            buttonHidingTrailingAnchor.isActive = false
            buttonShowingTrailingAnchor.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func cartButtonIsHidden() {
        cartButton.isHidden = true
        buttonShowingTrailingAnchor.isActive = false
        buttonHidingTrailingAnchor.isActive = true
    }
    
    func cartButtonIsVisible() {
        cartButton.isHidden = false
        buttonHidingTrailingAnchor.isActive = false
        buttonShowingTrailingAnchor.isActive = true
    }
    
    func cartButtonAnimation(updatedPrice: Double) {
        imageBackgroundWidthAnchor.isActive = false
        imageBackgroundTrailingAnchor.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.priceLabel.text = String(format: "$%.2f", updatedPrice)
            self.imageBackgroundTrailingAnchor.isActive = false
            self.imageBackgroundWidthAnchor.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
}

