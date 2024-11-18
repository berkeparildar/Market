//
//  MenuCellView.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//
import UIKit

class MenuCell: UICollectionViewCell {
    static let identifier = "MenuCell"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 2, height: 4)
        contentView.layer.shadowRadius = 6
        setupViews()
        setupConstraints()
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var restaurantImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .marketRed
        label.textAlignment = .left
        return label
    }()
}

// MARK: - VIEW SETUP
extension MenuCell {
    private func setupViews() {
        contentView.addSubview(restaurantImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        setupRestaurantImageConstraints()
        setupNameLabelConstraints()
        setupDescriptionLabelConstraints()
        setupPriceLabelConstraints()
    }
    
    private func setupRestaurantImageConstraints() {
        restaurantImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(restaurantImage.snp.height).multipliedBy(1.2)
        }
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func setupDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(restaurantImage.snp.leading).offset(-16)
        }
    }
    
    private func setupPriceLabelConstraints() {
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
    }
}

// MARK: - CONFUGRATION
extension MenuCell {
    func configure(with menu: Menu) {
        nameLabel.text = menu.name
        
        restaurantImage.isSkeletonable = true
        restaurantImage.showSkeleton(usingColor: .systemGray5)
        restaurantImage.kf.setImage(with: URL(string: menu.imageURL)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.restaurantImage.hideSkeleton()
            case .failure:
                self.restaurantImage.hideSkeleton()
            }
        }
        priceLabel.text = "$\(menu.price)"
        descriptionLabel.text = menu.description
    }
}
