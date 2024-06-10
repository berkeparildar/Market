//
//  TrialCategoryCollectionViewCell.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.06.2024.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let identifier: String = "categoryCell"

    let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(label)
    }
    
    func configure(categoryName: String, isSelected: Bool) {
            label.text = categoryName
            label.textColor = isSelected ? .yellow : .white
        }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
