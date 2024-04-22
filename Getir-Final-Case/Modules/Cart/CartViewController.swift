//
//  CartViewController.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 17.04.2024.
//

import UIKit

protocol CartViewControllerProtocol: AnyObject {
    func reloadData()
    func setupViews()
    func setupConstraints()
    func showError(_ message: String)
    func setTitle()
    func updateTotalPrice(price: Double)
    func insertCartItem(at indexPath: IndexPath)
    func reloadCartItem(at indexPath: IndexPath)
    func deleteCartItem(at indexPath: IndexPath)
}

protocol CartCellDelegate {
    
}

protocol SuggestedProductCellDelegate {
    
}

class CartViewController: UIViewController {
    
    var presenter: CartPresenter!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .getirLightGray
        collectionView.register(ProductCellView.self, forCellWithReuseIdentifier: ProductCellView.identifier)
        collectionView.register(CartCellView.self, forCellWithReuseIdentifier: CartCellView.identifier)
        collectionView.register(SectionHeaderSuggestedProduct.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var bottomBlock: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 8
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buyButtonContainer: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapBuyButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.text = "Siparişi Tamamla"
        label.backgroundColor = .getirPurple
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .getirPurple
        label.font = UIFont(name: "OpenSans-Bold", size: 20)
        label.text = "₺0,00"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func didTapBuyButton() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

extension CartViewController: CartViewControllerProtocol {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func insertCartItem(at indexPath: IndexPath) {
        collectionView.insertItems(at: [indexPath])
    }
    
    func reloadCartItem(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func deleteCartItem(at indexPath: IndexPath) {
        collectionView.deleteItems(at: [indexPath])
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        bottomBlock.addSubview(buyButtonContainer)
        buyButtonContainer.addSubview(buyButton)
        buyButton.addSubview(buttonLabel)
        buyButton.addSubview(priceLabel)
        view.addSubview(bottomBlock)
    }
    func updateTotalPrice(price: Double) {
        self.priceLabel.text = String(format: "₺%.2f", price)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate( [
            bottomBlock.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomBlock.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buyButtonContainer.heightAnchor.constraint(equalToConstant: 50),
            buyButtonContainer.topAnchor.constraint(equalTo: bottomBlock.topAnchor, constant: 12),
            buyButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            buyButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            buyButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            buyButton.topAnchor.constraint(equalTo: buyButtonContainer.topAnchor),
            buyButton.bottomAnchor.constraint(equalTo: buyButtonContainer.bottomAnchor),
            buyButton.leadingAnchor.constraint(equalTo: buyButtonContainer.leadingAnchor),
            buyButton.trailingAnchor.constraint(equalTo: buyButtonContainer.trailingAnchor),
            
            buttonLabel.leadingAnchor.constraint(equalTo: buyButton.leadingAnchor),
            buttonLabel.topAnchor.constraint(equalTo: buyButton.topAnchor),
            buttonLabel.bottomAnchor.constraint(equalTo: buyButton.bottomAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: buttonLabel.trailingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: buyButton.trailingAnchor, constant: -12),
            priceLabel.topAnchor.constraint(equalTo: buyButton.topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: buyButton.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomBlock.topAnchor),
        ])
    }
    
    func showError(_ message: String) {
        //showAlert(title: "Error", message: message)
    }
    
    func setTitle() {
        if let customNavBar = navigationController as? CustomNavigationController {
            customNavBar.setTitle(title: "Sepetim")
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: item.layoutSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(16)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                let sectionBackground = NSCollectionLayoutDecorationItem.background(
                    elementKind: "background-element-kind")
                section.decorationItems = [sectionBackground]
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
                let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width), heightDimension: .estimated(48))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
        layout.register(SectionBackground.self, forDecorationViewOfKind: "background-element-kind")
        return layout
    }
}

extension CartViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return presenter.numberOfProductsInCart()
        }
        return presenter.numberOfSuggestedProducts()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: CartCellView.identifier, for: indexPath) as! CartCellView
            CartCellBuilder.createModule(cellView: cellView, product: presenter.productInCart(indexPath.item), view: presenter)
            return cellView
        }
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCellView.identifier, for: indexPath) as! ProductCellView
        ProductCellBuilder.createModule(cellView: cellView, product: presenter.suggestedProduct(indexPath.item), navBarOwner: self, cartPresenter: presenter)
        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderView", for: indexPath) as! SectionHeaderSuggestedProduct
        return headerView
    }
    
}

extension CartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.tappedProduct(indexpath: indexPath)
    }
}

extension CartViewController: NavigationBarProtocol {
    func updatePriceInNavigationBar() {
        
    }
    
    func didTapRightButton() {
        
    }
}
