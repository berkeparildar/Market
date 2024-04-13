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
