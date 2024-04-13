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
        let width = (view.frame.size.width) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.6)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        collectionView.dataSource = self
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.borderWidth = 1
        collectionView.delegate = self
        collectionView.backgroundColor = .getirLightGray
        self.baseView.addSubview(collectionView)
        collectionView.register(ProductViewCell.self, forCellWithReuseIdentifier: "verticalProductCell")
    }
    
    func setupNavigationBar() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .getirPurple
            appearance.buttonAppearance = UIBarButtonItemAppearance(style: .plain)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = UIColor.getirPurple
        }
        let cartButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(goToCartAction))
        cartButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = cartButton
    }
    
    func setupView() {
        baseView = UIView(frame: UIWindow(frame: UIScreen.main.bounds).frame)
        baseView.backgroundColor = .getirLightGray
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
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            if sectionIndex == 1 {
                let fixedWidth = 103.67
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(fixedWidth), heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(8), top: .fixed(0), trailing: .fixed(8), bottom: .fixed(0))
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: item.layoutSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(8), trailing: .fixed(0), bottom: .fixed(8))
                
                let containerWidth = environment.container.effectiveContentSize.width
                let totalItemWidth = fixedWidth * 3
                let totalSpacing = item.edgeSpacing!.leading!.spacing + item.edgeSpacing!.trailing!.spacing
                let totalWidth = totalItemWidth + totalSpacing * 3
                let padding = (containerWidth - totalWidth) / 2
                let paddingInsets = max(0, padding)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: paddingInsets, leading: paddingInsets, bottom: 16, trailing: paddingInsets)
                let sectionBackground = NSCollectionLayoutDecorationItem.background(
                    elementKind: "background-element-kind")
                section.decorationItems = [sectionBackground]
                return section
                
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/1.8))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
                section.orthogonalScrollingBehavior = .continuous
                return section
                
            }
        }
        layout.register(SectionBackground.self, forDecorationViewOfKind: "background-element-kind")
        return layout
    }
}

extension ProductListingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if presenter.numberOfItemsVertical() == 0 {
        }
        return presenter.numberOfItemsVertical()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "verticalProductCell", for: indexPath) as! ProductViewCell
        cell.configure(model: presenter.product(indexPath.item))
        cell.delegate = presenter
        return cell
    }
}

extension ProductListingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(index: indexPath.row)
    }
}
