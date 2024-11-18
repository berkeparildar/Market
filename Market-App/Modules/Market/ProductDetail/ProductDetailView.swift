//
//  ProductDetailView.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

import UIKit
import Kingfisher

protocol ProductDetailViewProtocol: AnyObject {
    func updateCartButton(price: Double)
    func configure(with product: Product)
    func updateButtons(quantity: Int)
    func showCartButton()
    func hideCartButton()
}

class ProductDetailView: UIViewController {
    
    var presenter: ProductDetailPresenterProtocol!
    
    let processor = ResizingImageProcessor(referenceSize: CGSize(width: 100, height: 100))

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var productBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.marketBlack.cgColor
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
        label.textColor = .marketYellow
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "₺0,00"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .marketBlack
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.text = "Product Name"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .marketGray
        label.font = .systemFont(ofSize: 12)
        label.text = "Attribute"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonBlock: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.marketBlack.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 8
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .marketYellow
        button.layer.cornerRadius = 24
        button.setTitle("Add to Cart", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var quantityButtonsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.marketBlack.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 6
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.backgroundColor = .marketYellow
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var increaseQuantityButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .marketYellow
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var decreaseQuantityButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .marketYellow
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cartButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .marketLightGray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var cartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart.fill")
        imageView.tintColor = .marketYellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var cartImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var cartPriceLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.backgroundColor = .marketLightGray
        label.textColor = .marketYellow
        label.textAlignment = .center
        label.text = "$0,00"
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
}

// MARK: - VIEW CYCLES
extension ProductDetailView {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Detail"
        setupViews()
        setupConstraints()
        setupCartButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setProductData()
    }
}

// MARK: - VIEW SETUP
extension ProductDetailView {
    private func setupViews() {
        view.backgroundColor = .marketYellow
        view.addSubview(backgroundView)
        productBlock.addSubview(productImage)
        productBlock.addSubview(priceLabel)
        productBlock.addSubview(nameLabel)
        productBlock.addSubview(attributeLabel)
        view.addSubview(productBlock)
        buttonBlock.addSubview(addToCartButton)
        quantityButtonsBackground.addSubview(decreaseQuantityButton)
        quantityButtonsBackground.addSubview(quantityLabel)
        quantityButtonsBackground.addSubview(increaseQuantityButton)
        buttonBlock.addSubview(quantityButtonsBackground)
        view.addSubview(buttonBlock)
    }
    
    private func setupConstraints() {
        setupBackgroundViewConstraints()
        setupProductBlockConstraints()
        setupImageConstraints()
        setupPriceLabelConstraints()
        setupNameLabelConstraints()
        setupAttributeLabelConstraints()
        setupButtonBlockConstraints()
        setupAddToCartButtonConstraints()
        setupQuantityButtonsBackgroundConstraints()
        setupDecreaseQuantityButtonConstraints()
        setupQuantityLabelConstraints()
        setupIncreaseQuantityButtonConstraints()
    }
    
    private func setupBackgroundViewConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setupProductBlockConstraints() {
        productBlock.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    private func setupImageConstraints() {
        productImage.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.top.equalTo(productBlock.snp.top).offset(16)
            make.centerX.equalTo(productBlock.snp.centerX)
        }
    }
    
    private func setupPriceLabelConstraints() {
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(16)
            make.leading.equalTo(productBlock.snp.leading).offset(16)
            make.trailing.equalTo(productBlock.snp.trailing).offset(-16)
        }
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.leading.equalTo(productBlock.snp.leading).offset(16)
            make.trailing.equalTo(productBlock.snp.trailing).offset(-16)
        }
    }
    
    private func setupAttributeLabelConstraints() {
        attributeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(productBlock.snp.leading).offset(16)
            make.trailing.equalTo(productBlock.snp.trailing).offset(-16)
            make.bottom.equalTo(productBlock.snp.bottom).offset(-16)
        }
    }
    
    private func setupButtonBlockConstraints() {
        buttonBlock.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setupAddToCartButtonConstraints() {
        addToCartButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setupQuantityButtonsBackgroundConstraints() {
        quantityButtonsBackground.snp.makeConstraints { make in
            make.top.equalTo(buttonBlock.snp.top).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(48)
            make.leading.equalTo(quantityLabel.snp.leading).offset(-48)
            make.trailing.equalTo(quantityLabel.snp.trailing).offset(48)
            make.centerX.equalTo(buttonBlock.snp.centerX)
        }
    }
    
    private func setupDecreaseQuantityButtonConstraints() {
        decreaseQuantityButton.snp.makeConstraints { make in
            make.leading.equalTo(quantityButtonsBackground.snp.leading).offset(8)
            make.trailing.equalTo(quantityLabel.snp.leading).offset(-8)
            make.top.equalTo(quantityButtonsBackground.snp.top).offset(8)
            make.bottom.equalTo(quantityButtonsBackground.snp.bottom).offset(-8)
        }
    }
    
    private func setupQuantityLabelConstraints() {
        quantityLabel.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(48)
            make.centerY.equalTo(quantityButtonsBackground.snp.centerY)
            
        }
    }
    
    private func setupIncreaseQuantityButtonConstraints() {
        increaseQuantityButton.snp.makeConstraints { make in
            make.leading.equalTo(quantityLabel.snp.trailing).offset(8)
            make.trailing.equalTo(quantityButtonsBackground.snp.trailing).offset(-8)
            make.top.equalTo(quantityButtonsBackground.snp.top).offset(8)
            make.bottom.equalTo(quantityButtonsBackground.snp.bottom).offset(-8)
        }
    }
}

// MARK: - BUTTON ACTIONS
extension ProductDetailView {
    @objc func incrementButtonTapped() {
        presenter.didTapIncrementButton()
    }
    
    @objc func decrementButtonTapped () {
        presenter.didTapDecrementButton()
    }
    
    @objc func cartButtonTapped() {
        print("Cart Button Tapped")
        presenter.didTapCartButton()
    }
}

// MARK: - CART BUTTON
extension ProductDetailView {
    private func setupCartButton() {
        cartButtonView.addSubview(cartButton)
        cartButton.addSubview(cartPriceLabel)
        cartImageBackground.addSubview(cartImage)
        cartButton.addSubview(cartImageBackground)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButtonView)
        
        cartButtonView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(32)
        }
        
        cartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(160)
            make.height.equalTo(32)
        }
        
        cartImageBackground.snp.makeConstraints { make in
            make.leading.equalTo(cartButton.snp.leading)
            make.trailing.equalTo(cartButton.snp.leading).offset(32)
            make.top.equalTo(cartButton.snp.top)
            make.bottom.equalTo(cartButton.snp.bottom)
        }
        
        cartImage.snp.makeConstraints { make in
            make.leading.equalTo(cartButton.snp.leading).offset(6)
            make.centerY.equalTo(cartButton.snp.centerY)
            make.width.height.equalTo(20)
        }
        
        cartPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(cartImage.snp.trailing).offset(12)
            make.top.equalTo(cartButton.snp.top).offset(8)
            make.bottom.equalTo(cartButton.snp.bottom).offset(-8)
            make.trailing.equalTo(cartButton.snp.trailing).offset(-8)
        }
    }
}

// MARK: - PROTOCOL METHODS
extension ProductDetailView: ProductDetailViewProtocol {
    func showCartButton() {
        cartButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(8)
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.cartButton.superview?.layoutIfNeeded()
        })
    }
    
    func hideCartButton() {
        cartButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(160)
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.cartButton.superview?.layoutIfNeeded()
        })
    }
    
    func updateCartButton(price: Double) {
        let animationDuration = 0.3
        cartImageBackground.snp.updateConstraints { make in
            make.trailing.equalTo(cartButton.snp.leading).offset(96)
        }

        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let self = self else { return }
            self.cartImageBackground.superview?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let self = self else { return }

            self.cartPriceLabel.text = String(format: "$%.2f", price)
            
            self.cartImageBackground.snp.updateConstraints { make in
                make.trailing.equalTo(self.cartButton.snp.leading).offset(32)
            }
            
            UIView.animate(withDuration: animationDuration) {
                self.cartImageBackground.superview?.layoutIfNeeded()
            }
            
        })
    }
    
    func updateButtons(quantity: Int) {
        if quantity > 0 {
            quantityButtonsBackground.isHidden = false
            quantityLabel.text = "\(quantity)"
            addToCartButton.isHidden = true
        } else {
            quantityButtonsBackground.isHidden = true
            addToCartButton.isHidden = false
        }
    }
    
    func configure(with product: Product) {
        self.priceLabel.text = product.productPriceText
        self.nameLabel.text = product.name
        self.attributeLabel.text = product.description
        productImage.isSkeletonable = true
        productImage.showSkeleton(usingColor: .systemGray5)
        productImage.kf.setImage(with: URL(string: product.imageURL),
                                  placeholder: UIImage(named: "placeholder"),
                                  options: [
                                      .processor(processor),
                                      .scaleFactor(UIScreen.main.scale),
                                      .cacheOriginalImage
                                  ]) { [weak productImage] result in
                                      switch result {
                                      case .success(_):
                                          productImage?.hideSkeleton()
                                          break
                                      case .failure(_):
                                          productImage?.hideSkeleton()
                                          break
                                      }
                                  }
    }
}

