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

protocol ProductCellOwnerDelegate: AnyObject {
    func didTapAddButton(product: Product)
    func didTapRemoveButton(product: Product)
}

final class ProductListingViewController: UIViewController, LoadingShowable {
    
    var presenter: ProductListingPresenter!
    private var customNavigationBar: CustomNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    private lazy var collectionView: UICollectionView = {
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
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return sectionIndex == 0 ? self.horizontalSectionLayout() : self.verticalSectionLayout()
        }
        layout.register(SectionBackground.self, forDecorationViewOfKind: "background-element-kind")
        return layout
    }
    
    func horizontalSectionLayout() -> NSCollectionLayoutSection {
        let fixedWidth = 92.0
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(fixedWidth), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(fixedWidth), heightDimension: item.layoutSize.heightDimension)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(200))
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
        return section == 0 ? presenter.getSuggestedProductCount() : presenter.getProductCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCellView
        let product = indexPath.section == 0 ? presenter.getSuggestedProduct(indexPath.item) : presenter.getProduct(indexPath.item)
        ProductCellBuilder.createModule(cellView: cellView, product: product, cellOwner: self)
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
        presenter.didSelectItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.zPosition = 1
    }
    
}

extension ProductListingViewController: ProductCellOwnerDelegate {
    
    func didTapAddButton(product: Product) {
        presenter.didTapAddButtonFromCell(product: product)
        customNavigationBar.updatePrice()
    }
    
    func didTapRemoveButton(product: Product) {
        presenter.didTapRemoveButtonFromCell(product: product)
        customNavigationBar.updatePrice()
    }
}

extension ProductListingViewController: RightNavigationButtonProtocol {
    
    func updatePriceInNavigationBar() {
        customNavigationBar.updatePrice()
    }
    
    func didTapRightButton() {
        presenter.didTapCartButton()
    }
    
}
