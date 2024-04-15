//
//  ProductDetailViewController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 14.04.2024.
//

import UIKit

protocol ProductDetailViewControllerProtocol: AnyObject {
    func setupNavigationBar()
    func setupViews()
    func setupConstraints()
}

final class ProductDetailViewController: UIViewController {
    
    var presenter: ProductDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ProductDetailViewController: ProductDetailViewControllerProtocol {
    func setupConstraints() {
        <#code#>
    }
    
    func setupViews() {
        <#code#>
    }
    
    func setupNavigationBar() {
        
    }
}
