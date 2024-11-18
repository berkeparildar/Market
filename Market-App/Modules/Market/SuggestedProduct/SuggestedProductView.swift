//
//  SuggestedSuggestedProductView.swift
//  Market-App
//
//  Created by Berke Parıldar on 16.11.2024.
//

import UIKit
import Kingfisher

final class SuggestedProductView: UICollectionViewCell {
    static let identifier: String = "SuggestedProductCell"
    
    var cartUpdateDelegate: CartUpdateDelegate?
    var product: Product?
    
    let processor = ResizingImageProcessor(referenceSize: CGSize(width: 100, height: 100))
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
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
    
}

// MARK: - VIEW SETUP
extension SuggestedProductView {
    private func setupViews() {
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(attributeLabel)
        addSubview(buttonContainerView)
        buttonContainerView.addSubview(incrementButton)
    }
    
    private func setupConstraints() {
        setupImageConstraints()
        setupPriceLabelConstraints()
        setupNameLabelConstraints()
        setupAttributeLabelConstraints()
        setupButtonContainerConstraints()
        setupIncrementButtonConstraints()
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let addButtonPoint = incrementButton.convert(point, from: self)
        if incrementButton.bounds.contains(addButtonPoint) {
            return incrementButton
        }
        return super.hitTest(point, with: event)
    }
}

// MARK: - BUTTON ACTIONS
extension SuggestedProductView {
    @objc func incrementButtonTapped() {
        MarketCartService.shared.addProductToCart(product: product!)
        cartUpdateDelegate?.updateCart()
    }
}

// MARK: - PROTOCOL METHODS
extension SuggestedProductView {
    
    func configure(product: Product) {
        self.product = product
        iconImageView.isSkeletonable = true
        iconImageView.showSkeleton(usingColor: .systemGray5)
        iconImageView.kf.setImage(with: URL(string: product.imageURL),
                                  placeholder: UIImage(named: "placeholder"),
                                  options: [
                                      .processor(processor),
                                      .scaleFactor(UIScreen.main.scale),
                                      .cacheOriginalImage
                                  ]) { [weak iconImageView] result in
                                      switch result {
                                      case .success(_):
                                          iconImageView?.hideSkeleton()
                                          break
                                      case .failure(_):
                                          iconImageView?.hideSkeleton()
                                          break
                                      }
                                  }
        
        nameLabel.text = product.name
        priceLabel.text = product.productPriceText
        attributeLabel.text = product.description
    }
}
