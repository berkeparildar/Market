//
//  ProductListingViewController.swift
//  Market-App
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

protocol GroupCellOwnerDelegate: AnyObject {
    func didTapAddButton(product: Product)
    func didSelectProduct(product: Product)
    func didTapRemoveButton(product: Product)
}

final class ProductListingViewController: UIViewController, LoadingShowable {
    
    var presenter: ProductListingPresenter!
    var customNavigationBar: CustomNavigationController!
    var currentIndex: Int?
    
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
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .marketLightGray
        collectionView.register(ProductGroupCell.self, forCellWithReuseIdentifier: "groupCell")
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.register(ProductCellView.self, forCellWithReuseIdentifier: ProductCellView.identifier)
        collectionView.register(SectionBackground.superclass(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return sectionIndex == 0 ? CollectionViewLayoutStyle.categoryStyle : CollectionViewLayoutStyle.productGroupStyle
        }
        layout.register(SectionBackground.self, forDecorationViewOfKind: "background-element-kind")
        layout.register(SectionRedBackground.self, forDecorationViewOfKind: "background-red-element-kind")
        layout.register(SectionGreenBackground.self, forDecorationViewOfKind: "background-blue-element-kind")
        return layout
    }
    
}

extension ProductListingViewController: ProductListingViewControllerProtocol {
    func setupNavigationBar() {
        if let customNavController = navigationController as? CustomNavigationController {
            customNavigationBar = customNavController
            customNavigationBar.setTitle(title: "Products")
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
        return presenter.categories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
            let isSelected = (indexPath.row == currentIndex)
            cell.configure(categoryName: presenter.categories[indexPath.row].name, isSelected: isSelected)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as! ProductGroupCell
        cell.configure(products: presenter.categories[indexPath.row].products, delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderView", for: indexPath)
        headerView.backgroundColor = .marketLightGray
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            collectionView.scrollToItem(at: IndexPath(item: indexPath.item, section: 0), at: .centeredHorizontally, animated: true)
            if let previousSelectedIndex = currentIndex {
                let previousIndexPath = IndexPath(item: previousSelectedIndex, section: 0)
                if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CategoryCell {
                    previousCell.configure(categoryName: presenter.categories[previousSelectedIndex].name, isSelected: false)
                }
            }
            currentIndex = indexPath.row
            if let currentIndex = currentIndex {
                let currentIndexPath = IndexPath(item: currentIndex, section: 0)
                if let cell = collectionView.cellForItem(at: currentIndexPath) as? CategoryCell {
                    cell.configure(categoryName: presenter.categories[currentIndexPath.row].name, isSelected: true)
                }
            }
        }
    }
}

extension ProductListingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let previousSelectedIndex = currentIndex {
                let previousIndexPath = IndexPath(item: previousSelectedIndex, section: 0)
                if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CategoryCell {
                    previousCell.configure(categoryName: presenter.categories[previousSelectedIndex].name, isSelected: false)
                }
            }
            currentIndex = indexPath.row
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
                cell.configure(categoryName: presenter.categories[indexPath.row].name, isSelected: true)
            }
            collectionView.scrollToItem(at: IndexPath(item: indexPath.item, section: 1), at: .centeredHorizontally, animated: true)
        }
    }
}

extension ProductListingViewController: GroupCellOwnerDelegate {
    func didSelectProduct(product: Product) {
        presenter.didSelectItemAt(product: product)
    }
    
    func didTapAddButton(product: Product) {
        presenter.didTapAddButtonFromCell(product: product)
        customNavigationBar.updatePrice()
    }
    
    func didTapRemoveButton(product: Product) {
        presenter.didTapRemoveButtonFromCell(product: product)
        customNavigationBar.updatePrice()
    }
}

extension ProductListingViewController: RightNavigationButtonDelegate {
    func didTapRightButton() {
        presenter.didTapCartButton()
    }
}
