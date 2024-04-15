//
//  ProductListingViewController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import UIKit

protocol ProductListingViewControllerProtocol: AnyObject {
    func reloadData()
    func setupViews()
    func setupCollectionView()
    func showLoadingView()
    func hideLoadingView()
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
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        collectionView.dataSource = self
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.borderWidth = 1
        collectionView.delegate = self
        collectionView.backgroundColor = .getirLightGray
        collectionView.register(ProductCellView.self, forCellWithReuseIdentifier: "productCell")
        collectionView.register(SectionBackground.superclass(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
    }
    
    func setupNavigationBar() {
        if let customNavController = navigationController as? CustomNavigationController {
            customNavController.setTitle(title: "Ürünler")
            customNavController.updateNavigationBar()
        }
    }
    
    func setupViews() {
        baseView = UIView(frame: UIWindow(frame: UIScreen.main.bounds).frame)
        baseView.backgroundColor = .getirLightGray
        baseView.addSubview(collectionView)
        self.view.addSubview(baseView)
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
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
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: item.layoutSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                group.interItemSpacing = .flexible(16)
                
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                
                let sectionBackground = NSCollectionLayoutDecorationItem.background(
                    elementKind: "background-element-kind")
                section.decorationItems = [sectionBackground]
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width), heightDimension: .absolute(16))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
                
            } else {
                let fixedWidth = 92.0
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(fixedWidth), heightDimension: .estimated(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: item.layoutSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                let sectionBackground = NSCollectionLayoutDecorationItem.background(
                    elementKind: "background-element-kind")
                section.decorationItems = [sectionBackground]
                section.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width), heightDimension: .absolute(16))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
                
                return section
                
            }
        }
        layout.configuration.interSectionSpacing = 16
        layout.register(SectionBackground.self, forDecorationViewOfKind: "background-element-kind")
        return layout
    }
}

extension ProductListingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return presenter.numberOfSuggestedProducts()
        }
        return presenter.numberOfProducts()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCellView
            let cellInteractor = ProductCellInteractor()
            let cellPresenter = ProductCellPresenter(interactor: cellInteractor, view: cellView, product: presenter.suggestedProduct(indexPath.row))
            cellView.presenter = cellPresenter
            cellInteractor.output = cellPresenter
            cellInteractor.navBarNotifier = self
            cellView.configureWithPresenter()
            return cellView
        }
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCellView
        let cellInteractor = ProductCellInteractor()
        let cellPresenter = ProductCellPresenter(interactor: cellInteractor, view: cellView, product: presenter.product(indexPath.item))
        cellView.presenter = cellPresenter
        cellInteractor.output = cellPresenter
        cellInteractor.navBarNotifier = self
        cellView.configureWithPresenter()
        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderView", for: indexPath)
        headerView.backgroundColor = .getirLightGray
        return headerView
    }
}

extension ProductListingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(section: indexPath.section, index: indexPath.item)
    }
}

extension ProductListingViewController: UpdateNavigationBarProtocol {
    func updateNavigationBar() {
        if let customNavController = navigationController as? CustomNavigationController {
            customNavController.updateNavigationBar()
        }
    }
}
