//
//  CartViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 17.04.2024.
//

import UIKit

protocol CartViewControllerProtocol: AnyObject {
    func setupNavigationBar()
    func setupViews()
    func setupConstraints()
    func reloadData()
    func goBackToListing()
    func updateTotalPrice(price: Double, isAnimated: Bool)
    func insertCartItem(at indexPath: IndexPath)
    func reloadCartItem(at indexPath: IndexPath)
    func deleteCartItem(at indexPath: IndexPath)
}

protocol SuggestedCellOwnerDelegate: AnyObject {
    func didTapAddButtonFromSuggested(product: Product)
}

protocol CartCellOwnerDelegate: AnyObject {
    func didTapAddButtonFromCart(product: Product)
    func didTapRemoveButtonFromCart(product: Product)
}


class CartViewController: UIViewController {
    
    var presenter: CartPresenter!
    private var customNavigationBar: CustomNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .marketLightGray
        collectionView.register(SuggestedCellView.self, forCellWithReuseIdentifier: SuggestedCellView.identifier)
        collectionView.register(CartCellView.self, forCellWithReuseIdentifier: CartCellView.identifier)
        collectionView.register(SectionHeaderSuggestedProduct.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let bottomBlock: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.marketBlack.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 8
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buyButtonContainer: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.marketBlack.cgColor
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
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Complete Order"
        label.backgroundColor = .marketGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .marketGreen
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "$0,00"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return sectionIndex == 0 ? CollectionViewLayoutStyle.tableStyle : CollectionViewLayoutStyle.suggestedStyle
        }
        layout.register(SectionBackground.self, forDecorationViewOfKind: "background-element-kind")
        return layout
    }
}

extension CartViewController: CartViewControllerProtocol {
    func setupNavigationBar() {
        if let customNavController = navigationController as? CustomNavigationController {
            customNavigationBar = customNavController
            customNavigationBar.setTitle(title: "Cart")
            customNavigationBar.setButtonVisibility()
        }
    }

    func setupViews() {
        view.addSubview(collectionView)
        bottomBlock.addSubview(buyButtonContainer)
        buyButtonContainer.addSubview(buyButton)
        buyButton.addSubview(buttonLabel)
        buyButton.addSubview(priceLabel)
        view.addSubview(bottomBlock)
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
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomBlock.topAnchor),
        ])
    }
    
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

    func updateTotalPrice(price: Double, isAnimated: Bool) {
        if isAnimated {
            UIView.animate(withDuration: 0.3) {
                self.priceLabel.text = String(format: "$%.2f", price)
                self.view.layoutIfNeeded()
            }
        }
        else {
            self.priceLabel.text = String(format: "$%.2f", price)
        }
    }

    func goBackToListing() {
        customNavigationBar.popToRootViewController(animated: true)
    }

}

extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return presenter.getProductInCartCount()
        }
        return presenter.getSuggestedProductCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: CartCellView.identifier, for: indexPath) as! CartCellView
            CartCellBuilder.createModule(cellView: cellView, product: presenter.getProductInCart(indexPath.item), cellOwner: self)
            return cellView
        }
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedCellView.identifier, for: indexPath) as! SuggestedCellView
        SuggestedCellBuilder.createModule(cellView: cellView, product: presenter.getSuggestedProduct(indexPath.item), cellOwner: self)
        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderView", for: indexPath) as! SectionHeaderSuggestedProduct
        return headerView
    }
    
}

extension CartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(indexpath: indexPath)
    }
}

extension CartViewController: SuggestedCellOwnerDelegate {
    func didTapAddButtonFromSuggested(product: Product) {
        presenter.addButtonTappedFromSuggested(product: product)
    }
}

extension CartViewController: CartCellOwnerDelegate {
    func didTapAddButtonFromCart(product: Product) {
        presenter.addButtonTappedFromCart(product: product)
    }
    
    func didTapRemoveButtonFromCart(product: Product) {
        presenter.removeButtonTappedFromCart(product: product)
    }
}

extension CartViewController: RightNavigationButtonDelegate, ConfirmationShowable, PromptShowable {
    func didTapRightButton() {
        showConfitmation {
            self.presenter.didTapTrashButton()
            if let customNavBar = self.navigationController as? CustomNavigationController {
                customNavBar.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func didTapBuyButton() {
        showPrompt(message: String(format: "$%.2f", self.presenter.calculateTotalPrice())) {
            self.presenter.didTapTrashButton()
            if let customNavBar = self.navigationController as? CustomNavigationController {
                customNavBar.popToRootViewController(animated: true)
            }
        }
    }
}
