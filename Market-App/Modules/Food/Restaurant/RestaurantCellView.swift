//
//  RestaurantView.swift
//  Market-App
//
//  Created by Berke Parıldar on 17.11.2024.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    static let identifier = "RestaurantCell"
    
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
    
    private let categoryLogo: UIImageView = {
        var image = UIImage(systemName: "fork.knife")
        image = image?.applyingSymbolConfiguration(.init(pointSize: 12, weight: .bold))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .marketRed
        return imageView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    private let hoursLogo: UIImageView = {
        var image = UIImage(systemName: "clock")
        image = image?.applyingSymbolConfiguration(.init(pointSize: 12, weight: .bold))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .marketRed
        return imageView
    }()
    
    private lazy var hoursLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .left
        return label
    }()
}

// MARK: - VIEW SETUP
extension RestaurantCell {
    private func setupViews() {
        contentView.addSubview(restaurantImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLogo)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(hoursLogo)
        contentView.addSubview(hoursLabel)
    }
    
    private func setupConstraints() {
        setupRestaurantImageConstraints()
        setupNameLabelConstraints()
        setupCategoryLogoConstraints()
        setupCategoryLabelConstraints()
        setupHoursLogoConstraints()
        setupHoursLabelConstraints()
    }
    
    private func setupRestaurantImageConstraints() {
        restaurantImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(restaurantImage.snp.height).multipliedBy(1.2)
        }
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(restaurantImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    private func setupCategoryLogoConstraints() {
        categoryLogo.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(restaurantImage.snp.trailing).offset(8)
            make.width.height.equalTo(14)
        }
    }
    
    private func setupCategoryLabelConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLogo)
            make.leading.equalTo(categoryLogo.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    private func setupHoursLogoConstraints() {
        hoursLogo.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.leading.equalTo(restaurantImage.snp.trailing).offset(8)
            make.width.height.equalTo(14)
        }
    }
    
    private func setupHoursLabelConstraints() {
        hoursLabel.snp.makeConstraints { make in
            make.centerY.equalTo(hoursLogo)
            make.leading.equalTo(hoursLogo.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
}

// MARK: - CONFUGRATION
extension RestaurantCell {
    func configure(with restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        
        restaurantImage.isSkeletonable = true
        restaurantImage.showSkeleton(usingColor: .systemGray5)
        restaurantImage.kf.setImage(with: URL(string: restaurant.imageURL)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.restaurantImage.hideSkeleton()
            case .failure:
                self.restaurantImage.hideSkeleton()
            }
        }
        
        var categoryString = ""
        for index in 0..<restaurant.categories.count {
            let category = RestaurantService.shared.getCategories().first(where: { $0.id == restaurant.categories[index] })?.name ?? ""
            categoryString.append(category)
            if index != restaurant.categories.count - 1 {
                categoryString.append(", ")
            }
        }
        categoryLabel.text = categoryString
        hoursLabel.text = restaurant.workingHours;
    }
}
