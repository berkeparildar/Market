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
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textColor = .getirBlack
        return lbl
    }()
    
    lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.getirLightGray.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .getirGray
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .getirPurple
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemPurple, for: .normal)
        return button
    }()
    
    
    func setConstraints() {
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.red.cgColor
        
        addSubview(nameLabel)
        addSubview(attributeLabel)
        addSubview(priceLabel)
        addSubview(productImage)
        //addSubview(addButton)
        
        [nameLabel, attributeLabel, priceLabel, productImage, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            productImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            productImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -0),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor, multiplier: 1),
            
            priceLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -0),
            
            attributeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            attributeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            attributeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            attributeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)

            /*
             addButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
             addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
             addButton.widthAnchor.constraint(equalToConstant: 30),
             addButton.heightAnchor.constraint(equalToConstant: 30),*/
        ])
    }
    
    func configure(model: Product?) {
        nameLabel.text = model?.name ?? "Name"
        attributeLabel.text = model?.attribute ?? model?.shortDescription ?? ""
        priceLabel.text = model?.priceText ?? "price"
        setImage(from: model!.thumbnailURL)
        setConstraints()
    }
    
    private func setImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.productImage.image = image
            }
        }.resume()
    }
}
