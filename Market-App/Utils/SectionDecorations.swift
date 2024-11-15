//
//  SectionBackground.swift
//  Market-App
//
//  Created by Berke Parıldar on 10.04.2024.
//

import UIKit

/*
 These two classes are used by the CollectionViews in the Product Listing and Cart page.
 Section background is used for the background for sections, SectionHeaderSuggestedProduct is used in the Cart Page's
 Suggested Products' header.
 */

class SectionBackground: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SectionRedBackground: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SectionGreenBackground: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .marketLightOrange
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SectionHeaderSuggestedProduct: UICollectionReusableView {
    
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .marketLightGray
        self.isUserInteractionEnabled = false
        configureUILabel()
    }
    
    func configureUILabel() {
        title = UILabel()
        title.text = "Suggested Products"
        title.font = .boldSystemFont(ofSize: 14)
        title.textColor = .marketGreen
        title.backgroundColor = .marketLightGray
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
