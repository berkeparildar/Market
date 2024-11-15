//
//  ProductListingViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

import UIKit

protocol CartButtonDelegate: AnyObject {
    func didChangeCart()
}


protocol ProductListingViewProtocol: AnyObject {
    func reloadData()
    func updateCartButton(price: Double)
    func showLoadingView()
    func hideLoadingView()
    func showCartButton()
    func hideCartButton()
}

final class ProductListingViewController: UIViewController, LoadingShowable {
    
    var presenter: ProductListingPresenter!
    var currentIndex: Int?
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .marketYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.delaysContentTouches = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .marketLightGray
        
        collectionView.register(ProductListView.self,
                                forCellWithReuseIdentifier: ProductListView.identifier)
        collectionView.register(CategoryTabView.self,
                                forCellWithReuseIdentifier: CategoryTabView.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var cartButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .marketLightGray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        //button.addTarget(self, action: #selector(), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart.fill")
        imageView.tintColor = .marketYellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var cartImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.backgroundColor = .marketLightGray
        label.textColor = .marketYellow
        label.textAlignment = .center
        label.text = "$0,00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Market"
        view.backgroundColor = .marketYellow
        navigationController?.navigationBar.barTintColor = .marketYellow
        navigationController?.navigationBar.tintColor = .white
        presenter.getProducts()
        setupViews()
        setupConstraints()
        setupCartButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setupCartButton() {
        cartButtonView.addSubview(cartButton)
        cartButton.addSubview(priceLabel)
        cartImageBackground.addSubview(cartImage)
        cartButton.addSubview(cartImageBackground)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButtonView)
        
        
        cartButton.snp.makeConstraints { make in
            make.centerX.equalTo(cartButtonView.snp.centerX).offset(160)
            make.centerY.equalTo(cartButtonView.snp.centerY)
            make.height.equalTo(32)
        }
        
        cartImageBackground.snp.makeConstraints { make in
            make.leading.equalTo(cartButton.snp.leading)
            make.trailing.equalTo(cartButton.snp.leading).offset(32)
            make.top.equalTo(cartButton.snp.top)
            make.bottom.equalTo(cartButton.snp.bottom)
        }
        
        cartImage.snp.makeConstraints { make in
            make.leading.equalTo(cartButton.snp.leading).offset(6)
            make.centerY.equalTo(cartButton.snp.centerY)
            make.width.height.equalTo(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(cartImage.snp.trailing).offset(12)
            make.top.equalTo(cartButton.snp.top).offset(8)
            make.bottom.equalTo(cartButton.snp.bottom).offset(-8)
            make.trailing.equalTo(cartButton.snp.trailing).offset(-8)
        }
        
    }
    
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

extension ProductListingViewController: ProductListingViewProtocol {
    func showCartButton() {
        cartButton.snp.updateConstraints { make in
            make.centerX.equalTo(cartButtonView.snp.centerX).offset(-44)
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.cartButton.superview?.layoutIfNeeded()
        })
    }
    
    func hideCartButton() {
        cartButton.snp.updateConstraints { make in
            make.centerX.equalTo(cartButtonView.snp.centerX).offset(160)
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.cartButton.superview?.layoutIfNeeded()
        })
    }
    
    func updateCartButton(price: Double) {
        cartImageBackground.snp.updateConstraints { make in
            make.trailing.equalTo(cartButton.snp.leading).offset(96)
        }

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.cartImageBackground.superview?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let self = self else { return }

            self.priceLabel.text = String(format: "$%.2f", price)
            
            self.cartImageBackground.snp.updateConstraints { make in
                make.trailing.equalTo(self.cartButton.snp.leading).offset(32)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.cartImageBackground.superview?.layoutIfNeeded()
            }
        })
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
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.getCategoryCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryTabView.identifier, for: indexPath) as! CategoryTabView
            let isSelected = (indexPath.row == currentIndex)
            cell.configure(categoryName: presenter.getCategory(at: indexPath.row).name,
                           isSelected: isSelected)
            return cell
        }
        
        let category = presenter.getCategory(at: indexPath.item)
        let productListView = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductListView.identifier, for: indexPath) as! ProductListView
        let productListInteractor = ProductListInteractor()
        let productListPresenter = ProductListPresenter(products: category.products,
                                                        view: productListView,
                                                        interactor: productListInteractor)
        
        productListView.presenter = productListPresenter
        productListPresenter.cartButtonDelegate = self
        productListInteractor.output = productListPresenter
        
        return productListView
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            collectionView.scrollToItem(at: IndexPath(item: indexPath.item, section: 0),
                                        at: .centeredHorizontally, animated: true)
            if let previousSelectedIndex = currentIndex {
                let previousIndexPath = IndexPath(item: previousSelectedIndex, section: 0)
                if let previousCategoryTab = collectionView.cellForItem(
                    at: previousIndexPath) as? CategoryTabView {
                    previousCategoryTab.configure(
                        categoryName: presenter.getCategory(at: previousSelectedIndex).name,
                        isSelected: false)
                }
            }
            currentIndex = indexPath.row
            if let currentIndex = currentIndex {
                let currentIndexPath = IndexPath(item: currentIndex, section: 0)
                if let categoryTab = collectionView.cellForItem(
                    at: currentIndexPath) as? CategoryTabView {
                    categoryTab.configure(categoryName: presenter.getCategory(
                        at: currentIndex).name, isSelected: true)
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
                if let previousCategoryTab = collectionView.cellForItem(
                    at: previousIndexPath) as? CategoryTabView {
                    previousCategoryTab.configure(
                        categoryName: presenter.getCategory(at: previousSelectedIndex).name,
                        isSelected: false)
                }
            }
            currentIndex = indexPath.row
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryTabView {
                cell.configure(categoryName: presenter.getCategory(at: indexPath.row).name,
                               isSelected: true)
            }
            collectionView.scrollToItem(
                at: IndexPath(item: indexPath.item, section: 1),
                at: .centeredHorizontally, animated: true)
        }
    }
}

extension ProductListingViewController: CartButtonDelegate {
    func didChangeCart() {
        presenter.didChangeCart()
    }
}