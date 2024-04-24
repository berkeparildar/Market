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
    var customNavigationBar: CustomNavigationController!
    
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
            return sectionIndex == 0 ? CollectionViewLayoutStyle.horizontalStyle : CollectionViewLayoutStyle.verticalStyle
        }
        layout.register(SectionBackground.self, forDecorationViewOfKind: "background-element-kind")
        return layout
    }
    
}

extension ProductListingViewController: ProductListingViewControllerProtocol {
    
    /* Sets up the navigation bar as CustomNavigationBar, updates the title, the cart button's visibility,
     and the price seen in the cart button. */
    func setupNavigationBar() {
        if let customNavController = navigationController as? CustomNavigationController {
            customNavigationBar = customNavController
            customNavigationBar.setTitle(title: "Ürünler")
            customNavigationBar.setButtonVisibility()
            customNavigationBar.setPriceLabel()
        }
    }
    
    /* Add subviews to view. */
    func setupViews() {
        view.addSubview(collectionView)
    }
    
    /* Set the constraints according to design */
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /* Reload the collection view's data, is called by presenter when the data it presents updates */
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    /* Shows a loading view, called by presenter when the fetch operation is called */
    func showLoadingView() {
        showLoading()
    }
    
    /* Hides the loading view, called by presenter when the fetch operation is complete */
    func hideLoadingView() {
        hideLoading()
    }
}

extension ProductListingViewController: UICollectionViewDataSource {
    
    /* Assigns the product data to their sections. */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? presenter.getSuggestedProductCount() : presenter.getProductCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /* Cell configuration for the CollectionView. Both sections use the same cell, called ProductCellView.
     I wanted to follow the VIPER architecture in cell's as well, after having a very crowded cell class.
     The ProductViewCell has its own builder class and method, and also wants a class that conforms to
     CellOwnerDelegate as it's cell owner, in this case being this class. I wanted to keep the access to
     Cart Service restricted to page modules, so cell's call their own delegate functions when add or remove buttons
     are tapped. */
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
    
}

/* Functions that are called following the add or remove buttons from the cell. */
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

/* CustomNavigationBar has a RightNavigationButtonDelegate, and calles it's didTapRightButton method when the
button currently locating at the right of the navigation bar is tapped. For this view's case, it is the cart button. */
extension ProductListingViewController: RightNavigationButtonDelegate {
    
    func didTapRightButton() {
        presenter.didTapCartButton()
    }
    
}
