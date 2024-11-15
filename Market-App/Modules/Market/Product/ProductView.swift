//
//  ProductView.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

import UIKit
import Kingfisher

protocol ProductViewProtocol: AnyObject {
    func configure(product: Product)
    func updateProductQuantity(quantity: Int)
}

final class ProductView: UICollectionViewCell {
    
    static let identifier: String = "ProductCell"
  
    var presenter: ProductPresenterProtocol!
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.marketLightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .marketYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 12)
        label.textColor = .marketBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .marketGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.marketYellow.cgColor
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .default)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .marketYellow
        button.backgroundColor = .white
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.backgroundColor = .marketLightGray
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.textColor = .marketYellow
        label.textAlignment = .center
        label.text = "0"
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .default)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .marketYellow
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func incrementButtonTapped() {
        presenter.didTapIncrementButton()
    }
    
    @objc func decrementButtonTapped () {
        presenter.didTapDecrementButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(attributeLabel)
        addSubview(buttonContainerView)
        buttonContainerView.addSubview(decrementButton)
        buttonContainerView.addSubview(quantityLabel)
        buttonContainerView.addSubview(incrementButton)
    }
    
    private func setupConstraints() {
        setupImageConstraints()
        setupPriceLabelConstraints()
        setupNameLabelConstraints()
        setupAttributeLabelConstraints()
        setupButtonContainerConstraints()
        setupIncrementButtonConstraints()
        setupQuantityLabelConstraints()
        setupSubtractButtonConstraints()
    }
    
    private func showStepper() {
        buttonContainerView.snp.updateConstraints { make in
            make.height.equalTo(96)
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
        }
    }
    
    private func hideStepper() {
        buttonContainerView.snp.updateConstraints { make in
            make.height.equalTo(32)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func setDecrementIcon(systemName: String) {
        decrementButton.setImage(UIImage(systemName: systemName), for: .normal)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
        }
    }
    
    private func setupImageConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(iconImageView.snp.width)
        }
    }
    
    private func setupPriceLabelConstraints() {
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupAttributeLabelConstraints() {
        attributeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupButtonContainerConstraints() {
        buttonContainerView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.top).offset(-8)
            make.leading.equalTo(iconImageView.snp.trailing).offset(-24)
            make.trailing.equalTo(iconImageView.snp.trailing).offset(8)
            make.height.equalTo(32)
        }
    }
    
    private func setupIncrementButtonConstraints() {
        incrementButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.width.equalTo(32)
        }
    }
    
    private func setupQuantityLabelConstraints() {
        quantityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(buttonContainerView.snp.centerX)
            make.centerY.equalTo(incrementButton.snp.centerY).offset(32)
            make.width.height.equalTo(24)
        }
    }
    
    private func setupSubtractButtonConstraints() {
        decrementButton.snp.makeConstraints { make in
            make.centerX.equalTo(buttonContainerView.snp.centerX)
            make.centerY.equalTo(incrementButton.snp.centerY).offset(64)
            make.width.height.equalTo(32)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let addButtonPoint = incrementButton.convert(point, from: self)
        if incrementButton.bounds.contains(addButtonPoint) {
            return incrementButton
        }
        let deleteButtonPoint = decrementButton.convert(point, from: self)
        if decrementButton.bounds.contains(deleteButtonPoint) {
            return decrementButton
        }
        return super.hitTest(point, with: event)
    }
}

extension ProductView: ProductViewProtocol {
    
    func updateProductQuantity(quantity: Int) {
        quantityLabel.text = "\(quantity)"
        if quantity > 0 {
            showStepper()
            if quantity == 1 {
                setDecrementIcon(systemName: "trash")
            }
            else {
                setDecrementIcon(systemName: "minus")
            }
        }
        else {
            hideStepper()
        }
    }
    
    func configure(product: Product) {
        iconImageView.kf.setImage(with: URL(string: "https://picsum.photos/200"))
        nameLabel.text = product.name
        priceLabel.text = product.productPriceText
        attributeLabel.text = product.description
        presenter.getProductCount()
    }
}
