//
//  CategoryTabView.swift
//  Market-App
//
//  Created by Berke Parıldar on 13.11.2024.
//

import UIKit

class CategoryTabView: UICollectionViewCell {
   static let identifier: String = "CategoryTabView"

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
       label.textColor = isSelected ? .black : .marketOrange
       }
   
   func setupConstraints() {
       label.snp.makeConstraints { make in
           make.edges.equalToSuperview()
       }
   }
}
