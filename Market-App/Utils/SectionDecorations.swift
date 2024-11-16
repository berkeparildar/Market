//
//  SectionBackground.swift
//  Market-App
//
//  Created by Berke Parıldar on 10.04.2024.
//

import UIKit

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

class MarketCartHeaderView: UICollectionReusableView {
    
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .marketLightOrange
        self.isUserInteractionEnabled = false
        title = UILabel()
        title.font = .boldSystemFont(ofSize: 14)
        title.textColor = .marketOrange
        title.backgroundColor = .clear
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    func configureUILabel(titleText: String, backgroundColor: UIColor) {
        title.text = titleText
        self.backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
