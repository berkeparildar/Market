//
//  SectionBackground.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 10.04.2024.
//

import UIKit

class SectionBackground: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SectionHeaderSuggestedProduct: UICollectionReusableView {
    
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .getirLightGray
        configureUILabel()
    }
    
    func configureUILabel() {
        title = UILabel()
        title.text = "Önerilen Ürünler"
        title.font = UIFont(name: "OpenSans-SemiBold", size: 12)
        title.backgroundColor = .getirLightGray
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
