//
//  ProductListingViewController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 9.04.2024.
//

import UIKit

protocol ProductListingViewControllerProtocol: AnyObject {
    func setupNavigationBar()
    func setupViews()
    func setupConstraints()
    func reloadData()
    func showLoadingView()
    func hideLoadingView()
}

final class ProductListingViewController: UIViewController, LoadingShowable {
    
    var presenter: ProductListingPresenter!
    var customNavigationBar: CustomNavigationController!
    
    lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        collectionView.backgroundColor = .getirLightGray
        collectionView.register(ProductCellView.self, forCellWithReuseIdentifier: ProductCellView.identifier)
        collectionView.register(SectionBackground.superclass(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return sectionIndex == 0 ? self.horizontalSectionLayout() : self.verticalSectionLayout()
        }
        layout.configuration.interSectionSpacing = 16
        layout.register(SectionBackground.self, forDecorationViewOfKind: "background-element-kind")
        return layout
    }
    
    func horizontalSectionLayout() -> NSCollectionLayoutSection {
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
    
    func verticalSectionLayout() -> NSCollectionLayoutSection {
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
    }
    
}

extension ProductListingViewController: ProductListingViewControllerProtocol {
    
    func setupNavigationBar() {
        if let customNavController = navigationController as? CustomNavigationController {
            customNavigationBar = customNavController
            customNavigationBar.setTitle(title: "Ürünler")
            customNavigationBar.setButtonVisibility()
            customNavigationBar.setPriceLabel()
        }
    }
    
    func setupViews() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
}

extension ProductListingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? presenter.numberOfSuggestedProducts() : presenter.numberOfProducts()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCellView
        let product = indexPath.section == 0 ? presenter.suggestedProduct(indexPath.item) : presenter.product(indexPath.item)
        ProductCellBuilder.createModule(cellView: cellView, product: product, navBarOwner: self)
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
        presenter.didSelectItemAt(section: indexPath.section, index: indexPath.row)
    }
    
}

extension ProductListingViewController: NavigationBarProtocol {
    
    func updatePriceInNavigationBar() {
        customNavigationBar.updatePrice()
    }
    
    func didTapRightButton() {
        presenter.didTapCartButton()
    }
    
}
