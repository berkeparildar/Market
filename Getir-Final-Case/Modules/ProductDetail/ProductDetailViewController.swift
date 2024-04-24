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
    func setProductData(_ product: Product)
    func configureViewWithCartCount()
}

final class ProductDetailViewController: UIViewController {
    
    var presenter: ProductDetailPresenter!
    /* Constraint values for the button block.  */
    private var productIsInCartConstraints: NSLayoutConstraint!
    private var productIsNotInCartConstraints: NSLayoutConstraint!
    
    private var customNavigationBar: CustomNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    //MARK: - Views
    private let productBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .getirPurple
        label.font = UIFont(name: "OpenSans-Bold", size: 20)
        label.text = "₺0,00"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .getirBlack
        label.numberOfLines = 0
        label.font = UIFont(name: "OpenSans-Bold", size: 16)
        label.text = "Product Name"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .getirGray
        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
        label.text = "Attribute"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonBlock: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 8
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .getirPurple
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapAddToCartButton), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.backgroundColor = .getirPurple
        label.text = "Sepete Ekle"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var quantityButtonsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 6
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 16)
        label.backgroundColor = .getirPurple
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var increaseQuantityButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .getirPurple
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapIncreaseQuantityButton), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var decreaseQuantityButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .getirPurple
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapDecreaseQuantityButton), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func didTapAddToCartButton() {
        presenter.didTapAddToCartButton()
        customNavigationBar.updatePrice()
    }
    
    @objc func didTapIncreaseQuantityButton() {
        presenter.didTapAddToCartButton()
        customNavigationBar.updatePrice()
    }
    
    @objc func didTapDecreaseQuantityButton() {
        presenter.didTapRemoveFromCartButton()
        customNavigationBar.updatePrice()
    }
    //MARK: -
}

extension ProductDetailViewController: ProductDetailViewControllerProtocol {
    
    /* Sets up the navigation bar as CustomNavigationBar, updates the title, the cart button's visibility,
     and the price seen in the cart button. */
    func setupNavigationBar() {
        if let customNavController = navigationController as? CustomNavigationController {
            customNavigationBar = customNavController
            customNavigationBar.setTitle(title: "Ürün Detayı")
            customNavigationBar.setButtonVisibility()
            customNavigationBar.setPriceLabel()
        }
    }
    
    /* Add subviews to view. */
    func setupViews() {
        view.backgroundColor = .white
        productBlock.addSubview(productImage)
        productBlock.addSubview(priceLabel)
        productBlock.addSubview(nameLabel)
        productBlock.addSubview(attributeLabel)
        view.addSubview(productBlock)
        addToCartButton.addSubview(buttonTextLabel)
        buttonBlock.addSubview(addToCartButton)
        quantityButtonsBackground.addSubview(decreaseQuantityButton)
        quantityButtonsBackground.addSubview(quantityLabel)
        quantityButtonsBackground.addSubview(increaseQuantityButton)
        buttonBlock.addSubview(quantityButtonsBackground)
        view.addSubview(buttonBlock)
    }
    
    /* Set the constraints according to design */
    func setupConstraints() {
        
        /* The value of the current window's bottom insets, the position of the
         button block at the bottom varies according to this*/
        let bottomInsets = UIApplication.shared.windows.first(where: \.isKeyWindow)?.safeAreaInsets.bottom
        
        productIsNotInCartConstraints = addToCartButton.topAnchor.constraint(equalTo: buttonBlock.topAnchor, constant: 16)
        productIsInCartConstraints = quantityButtonsBackground.topAnchor.constraint(equalTo: buttonBlock.topAnchor, constant: 16)
        
        NSLayoutConstraint.activate([
            productBlock.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            productBlock.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productBlock.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productBlock.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            productImage.widthAnchor.constraint(equalToConstant: 200),
            productImage.heightAnchor.constraint(equalToConstant: 200),
            productImage.topAnchor.constraint(equalTo: productBlock.topAnchor, constant: 16),
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
            
            addToCartButton.bottomAnchor.constraint(equalTo: buttonBlock.bottomAnchor, constant: bottomInsets! > 0 ? -bottomInsets! : -bottomInsets! - 16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.leadingAnchor.constraint(equalTo: buttonBlock.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: buttonBlock.trailingAnchor, constant: -16),
            
            
            buttonTextLabel.centerXAnchor.constraint(equalTo: addToCartButton.centerXAnchor),
            buttonTextLabel.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            buttonTextLabel.topAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: 15),
            buttonTextLabel.bottomAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: -15),
            
            quantityButtonsBackground.bottomAnchor.constraint(equalTo: buttonBlock.bottomAnchor, constant: bottomInsets! > 0 ? -bottomInsets! : -bottomInsets! - 16),
            quantityButtonsBackground.heightAnchor.constraint(equalToConstant: 48),
            quantityButtonsBackground.centerXAnchor.constraint(equalTo: buttonBlock.centerXAnchor),
            
            decreaseQuantityButton.heightAnchor.constraint(equalToConstant: 48),
            decreaseQuantityButton.widthAnchor.constraint(equalToConstant: 48),
            decreaseQuantityButton.centerYAnchor.constraint(equalTo: quantityButtonsBackground.centerYAnchor),
            decreaseQuantityButton.leadingAnchor.constraint(equalTo: quantityButtonsBackground.leadingAnchor),
            decreaseQuantityButton.trailingAnchor.constraint(equalTo: increaseQuantityButton.leadingAnchor, constant: -48),
            
            quantityLabel.heightAnchor.constraint(equalToConstant: 48),
            quantityLabel.centerYAnchor.constraint(equalTo: quantityButtonsBackground.centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: decreaseQuantityButton.trailingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: increaseQuantityButton.leadingAnchor),
            
            increaseQuantityButton.heightAnchor.constraint(equalToConstant: 48),
            increaseQuantityButton.widthAnchor.constraint(equalToConstant: 48),
            increaseQuantityButton.centerYAnchor.constraint(equalTo: quantityButtonsBackground.centerYAnchor),
            increaseQuantityButton.leadingAnchor.constraint(equalTo: decreaseQuantityButton.trailingAnchor, constant: 48),
            increaseQuantityButton.trailingAnchor.constraint(equalTo: quantityButtonsBackground.trailingAnchor),
        ])
    }

    /* Configure the view according to the Product data*/
    func setProductData(_ product: Product) {
        self.priceLabel.text = product.productPriceText
        self.nameLabel.text = product.productName
        self.attributeLabel.text = product.productDescription
        self.productImage.kf.setImage(with: product.imageURL)
        self.quantityLabel.text = String(product.quantityInCart)
    }
    
    /* Configuration to whether to show the "Add to cart" button or the steppers
    by checking the current count in the cart. Also sets the image of remove
     button to trash if count is one. */
    func configureViewWithCartCount() {
        let productCount = presenter.getProductQuantity()
        if productCount > 0 {
            showQuantityButtons()
            let newImage = productCount == 1 ? UIImage(systemName: "trash") : UIImage(systemName: "minus")
            UIView.animate(withDuration: 0.3) {
                self.decreaseQuantityButton.setImage(newImage, for: .normal)
                self.quantityLabel.text = String(productCount)
                self.view.layoutIfNeeded()
            }
        }
        else {
            showAddToCartButton()
        }
    }
    
    // Hide addToCart button, show stepper, activate the constraints
    func showQuantityButtons() {
        self.addToCartButton.isHidden = true
        self.buttonTextLabel.isHidden = true
        self.quantityButtonsBackground.isHidden = false
        self.decreaseQuantityButton.isHidden = false
        self.quantityLabel.isHidden = false
        self.increaseQuantityButton.isHidden = false
        self.quantityLabel.text = String(presenter.getProductQuantity())
        productIsNotInCartConstraints.isActive = false
        productIsInCartConstraints.isActive = true
    }
    
    // Show addToCart button, hide stepper, activate the constraints
    func showAddToCartButton() {
        addToCartButton.isHidden = false
        buttonTextLabel.isHidden = false
        quantityButtonsBackground.isHidden = true
        decreaseQuantityButton.isHidden = true
        quantityLabel.isHidden = true
        productIsInCartConstraints.isActive = false
        productIsNotInCartConstraints.isActive = true
    }
    
}


extension ProductDetailViewController: RightNavigationButtonDelegate {
    /* CustomNavigationBar has a RightNavigationButtonDelegate, and calles it's didTapRightButton method when the
    button currently locating at the right of the navigation bar is tapped. For this view's case, it is the cart button. */
    func didTapRightButton() {
        presenter.didTapCartButton()
    }
    
}
