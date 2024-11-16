//
//  CartProductView.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

import UIKit
import Kingfisher

protocol CartProductViewProtocol: AnyObject {
    func updateProductQuantity(quantity: Int)
    func configure(with product: MarketCartEntity)
}

class CartProductView: UICollectionViewCell {
    
    static let identifier = "CartCell"
    var presenter: CartProductPresenterProtocol!
    
    let processor = ResizingImageProcessor(referenceSize: CGSize(width: 100, height: 100))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .marketBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productImage: UIImageView = {
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
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .marketGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .marketYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var buttonSection: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.marketBlack.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 6
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
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
        button.tintColor = .marketYellow
        button.layer.cornerRadius = 16
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .marketLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.tintColor = .marketYellow
        button.layer.cornerRadius = 16
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .marketYellow
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

// MARK: - VIEW SETUP
extension CartProductView {
    private func setupViews() {
        baseView.addSubview(productImage)
        textSection.addSubview(nameLabel)
        textSection.addSubview(attributeLabel)
        textSection.addSubview(priceLabel)
        baseView.addSubview(textSection)
        buttonSection.addSubview(deleteButton)
        buttonSection.addSubview(quantityLabel)
        buttonSection.addSubview(addButton)
        baseView.addSubview(buttonSection)
        contentView.addSubview(baseView)
        contentView.addSubview(seperator)
    }
    
    private func setupConstraints() {
        setupBaseViewConstraints()
        setupProductImageConstraints()
        setupTextSectionConstraints()
        setupNameLabelConstraints()
        setupAttributeLabelConstraints()
        setupPriceLabelConstraints()
        setupButtonSectionConstraints()
        setupDeleteButtonConstraints()
        setupQuantityLabelConstraints()
        setupAddButtonConstraints()
        setupSeperatorConstraints()
    }
    
    private func setDecrementIcon(systemName: String) {
        deleteButton.setImage(UIImage(systemName: systemName), for: .normal)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
        }
    }
    
    private func setupBaseViewConstraints() {
        baseView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func setupProductImageConstraints() {
        productImage.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading)
            make.top.equalTo(baseView.snp.top)
            make.centerY.equalTo(baseView.snp.centerY)
            make.width.equalTo(78)
            make.height.equalTo(78)
        }
    }
    
    private func setupTextSectionConstraints() {
        textSection.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.trailing).offset(16)
            make.centerY.equalTo(baseView.snp.centerY)
            make.trailing.equalTo(buttonSection.snp.leading).offset(-16)
        }
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(textSection.snp.top)
            make.leading.equalTo(textSection.snp.leading)
            make.trailing.equalTo(textSection.snp.trailing)
            make.bottom.equalTo(attributeLabel.snp.top).offset(-2)
        }
    }
    
    private func setupAttributeLabelConstraints() {
        attributeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(textSection.snp.leading)
            make.trailing.equalTo(textSection.snp.trailing)
            make.bottom.equalTo(priceLabel.snp.top).offset(-4)
        }
    }
    
    private func setupPriceLabelConstraints() {
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(attributeLabel.snp.bottom).offset(4)
            make.leading.equalTo(textSection.snp.leading)
            make.trailing.equalTo(textSection.snp.trailing)
            make.bottom.equalTo(textSection.snp.bottom).offset(-8)
        }
    }
    
    private func setupButtonSectionConstraints() {
        buttonSection.snp.makeConstraints { make in
            make.centerY.equalTo(baseView.snp.centerY)
            make.trailing.equalTo(baseView.snp.trailing)
            make.leading.equalTo(textSection.snp.trailing).offset(16)
        }
    }
    
    private func setupDeleteButtonConstraints() {
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(buttonSection.snp.leading)
            make.top.equalTo(buttonSection.snp.top)
            make.bottom.equalTo(buttonSection.snp.bottom)
            make.trailing.equalTo(quantityLabel.snp.leading)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
    }
    
    private func setupQuantityLabelConstraints() {
        quantityLabel.snp.makeConstraints { make in
            make.leading.equalTo(deleteButton.snp.trailing)
            make.top.equalTo(buttonSection.snp.top)
            make.bottom.equalTo(buttonSection.snp.bottom)
            make.trailing.equalTo(addButton.snp.leading)
            make.width.equalTo(38)
            make.height.equalTo(32)
        }
    }
    
    private func setupAddButtonConstraints() {
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(quantityLabel.snp.trailing)
            make.top.equalTo(buttonSection.snp.top)
            make.bottom.equalTo(buttonSection.snp.bottom)
            make.trailing.equalTo(buttonSection.snp.trailing)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
    }
    
    private func setupSeperatorConstraints() {
        seperator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(baseView.snp.leading).offset(16)
            make.trailing.equalTo(baseView.snp.trailing).offset(-16)
            make.top.equalTo(baseView.snp.bottom).offset(12)
        }
    }
}


// MARK: - BUTTON ACTIONS
extension CartProductView {
    @objc func incrementButtonTapped() {
        presenter.didTapIncrementButton()
    }
    
    @objc func decrementButtonTapped() {
        presenter.didTapDecrementButton()
    }
}


extension CartProductView: CartProductViewProtocol {
    func updateProductQuantity(quantity: Int) {
        quantityLabel.text = "\(quantity)"
        if quantity > 0 {
            if quantity == 1 {
                setDecrementIcon(systemName: "trash")
            }
            else {
                setDecrementIcon(systemName: "minus")
            }
        }
        else {
        }
    }
    
    func configure(with product: MarketCartEntity) {
        nameLabel.text = product.product.name
        attributeLabel.text = product.product.description
        priceLabel.text = product.product.productPriceText
        productImage.kf.setImage(with: URL(string: product.product.imageURL),
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
        quantityLabel.text = "\(product.quantity)"
        let imageName = product.quantity > 0 ? "minus" : "trash"
        setDecrementIcon(systemName: imageName)
    }
}
