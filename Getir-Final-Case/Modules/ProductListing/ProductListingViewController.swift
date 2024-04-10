//
//  ProductListingViewController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import UIKit

protocol ProductListingViewControllerProtocol: AnyObject {
    func reloadData()
    func setupView()
    func setupVerticalCollectionView()
    func showLoadingView()
    func hideLoadingView()
    func setTitle(_ title: String)
    func showError(_ message: String)
    func setupNavigationBar()
}

final class ProductListingViewController: BaseViewController {
    
    var presenter: ProductListingPresenter!
    var collectionView: UICollectionView!
    var baseView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension ProductListingViewController: ProductListingViewControllerProtocol {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupVerticalCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.size.width - 20) / 3
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: self.view.safeAreaLayoutGuide.layoutFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        self.baseView.addSubview(collectionView)
        collectionView.register(ProductViewCell.self, forCellWithReuseIdentifier: "verticalProductCell")
    }
    
    func setupNavigationBar() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemPurple
            appearance.buttonAppearance = UIBarButtonItemAppearance(style: .plain)
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        }
        let cartButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(goToCartAction))
        cartButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = cartButton
    }
    
    func setupView() {
        baseView = UIView(frame: UIWindow(frame: UIScreen.main.bounds).frame)
        baseView.backgroundColor = .systemPurple
        self.view.addSubview(baseView)
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func showError(_ message: String) {
        showAlert(title: "Error", message: message)
    }
    
    @objc private func goToCartAction() {
        presenter.tappedCart()
    }
}

extension ProductListingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if presenter.numberOfItemsVertical() == 0 {
            // show empty message
        }
        return presenter.numberOfItemsVertical()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "verticalProductCell", for: indexPath) as! ProductViewCell
        cell.configure(model: presenter.product(indexPath.item))
        return cell
    }
}

extension ProductListingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(index: indexPath.row)
    }
}
