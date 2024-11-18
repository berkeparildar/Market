//
//  MenuHeader.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//


import UIKit

class MenuHeaderView: UICollectionReusableView {
    static let identifier = "MenuHeaderView"
    
    private let photo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .marketRed
        label.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(photo)
        addSubview(backgroundView)
        backgroundView.addSubview(nameLabel)
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(priceLabel)
        addSubview(firstTitle)
             
        photo.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
     
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(photo.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(8)
            make.leading.equalTo(backgroundView.snp.leading).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(backgroundView).inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalTo(backgroundView.snp.leading).offset(16)
            make.bottom.equalTo(backgroundView.snp.bottom).offset(-8)
        }
        
        firstTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(backgroundView.snp.bottom).offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with menu: Menu) {
        nameLabel.text = menu.name
        
        photo.isSkeletonable = true
        photo.showSkeleton(usingColor: .systemGray5)
        photo.kf.setImage(with: URL(string: menu.imageURL)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photo.hideSkeleton()
            case .failure:
                self.photo.hideSkeleton()
            }
        }

        descriptionLabel.text = menu.description
        
        priceLabel.text = "$\(menu.price)"
        
        firstTitle.text = menu.options.first?.title
    }
}
