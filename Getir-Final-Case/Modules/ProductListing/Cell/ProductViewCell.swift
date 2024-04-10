//
//  ProductViewCell.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 10.04.2024.
//

import UIKit

class ProductViewCell: UICollectionViewCell {
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    func setConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: self.bounds.width),
            nameLabel.heightAnchor.constraint(equalToConstant: self.bounds.height)
        ])
    }
    
    func configure(model: Product?) {
        nameLabel.text = model?.name ?? "a"
        
            setConstraints()
        }
}
