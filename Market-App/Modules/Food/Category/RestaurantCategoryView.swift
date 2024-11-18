//
//  FoodCategoryView.swift
//  Market-App
//
//  Created by Berke Parıldar on 17.11.2024.
//

import UIKit
import Kingfisher

class RestaurantCategoryCell: UICollectionViewCell {
    static let identifier = "FoodCategoryCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .marketLightGray
        contentView.addSubview(categoryImage)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 1
        
        categoryImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(categoryImage.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryImage.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: RestaurantCategory) {
        categoryImage.isSkeletonable = true
        categoryImage.showSkeleton(usingColor: .systemGray5)
        categoryImage.kf.setImage(with: URL(string: category.imageURL)) { [weak self] result in
            switch result {
            case .success(_):
                self?.categoryImage.hideSkeleton()
            case .failure(_):
                self?.categoryImage.hideSkeleton()
            }
        }
        titleLabel.text = category.name
    }
}
