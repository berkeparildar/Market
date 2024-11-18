//
//  RestaurantHeader.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

import UIKit

class RestaurantHeaderView: UICollectionReusableView {
    static let identifier = "RestaurantHeaderView"
    
    private let restaurantImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var backgroundCornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .marketRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let firstTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .marketRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(restaurantImage)
        addSubview(backgroundCornerView)
        addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(categoryLogo)
        backgroundView.addSubview(categoryLabel)
        backgroundView.addSubview(hoursLogo)
        backgroundView.addSubview(hoursLabel)
        addSubview(firstTitle)
        
        restaurantImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        backgroundCornerView.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(restaurantImage.snp.bottom)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(restaurantImage.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(-4)
            make.leading.equalTo(backgroundView.snp.leading).offset(16)
        }
        
        categoryLogo.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(backgroundView.snp.leading).offset(16)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(categoryLogo.snp.trailing).offset(4)
        }
        
        hoursLogo.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(categoryLabel.snp.trailing).offset(8)
        }
        
        hoursLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(hoursLogo.snp.trailing).offset(4)
            make.bottom.equalTo(backgroundView.snp.bottom).offset(-16)
        }
        
        firstTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(backgroundView.snp.bottom).offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with restaurant: Restaurant) {
        titleLabel.text = restaurant.name
        
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
        
        hoursLabel.text = restaurant.workingHours
        
        firstTitle.text = restaurant.menuGroups.first?.title
    }
}
