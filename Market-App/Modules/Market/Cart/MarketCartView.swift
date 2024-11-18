//
//  MarketCartView.swift
//  Market-App
//
//  Created by Berke Parıldar on 15.11.2024.
//

import UIKit

protocol MarketCartViewProtocol: AnyObject {
    func reloadData()
    func deleteItems(at indexPaths: [IndexPath])
    func insertItems(at indexPaths: [IndexPath])
    func updatePriceLabel(price: Double)
}

protocol CartUpdateDelegate: AnyObject {
    func updateCart()
}

class MarketCartView: UIViewController {
    
    var presenter: MarketCartPresenterProtocol!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame,
                                              collectionViewLayout: createCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .marketLightOrange
        collectionView.register(CartProductView.self,
                                forCellWithReuseIdentifier: CartProductView.identifier)
        collectionView.register(SuggestedProductView.self,
                                forCellWithReuseIdentifier: SuggestedProductView.identifier)
        
        collectionView.register(MarketCartHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
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
    
    lazy var buyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.backgroundColor = .marketYellow
        button.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Complete Order", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .marketYellow
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "$0,00"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trashButton: UIBarButtonItem = {
        var image = UIImage(systemName: "trash")
        image = image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 14,
                                                                               weight: .bold))
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(trashButtonTapped))
        return button
    }()
}

// MARK: - VIEW CYCLES
extension MarketCartView {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        view.backgroundColor = .marketYellow
        setupViews()
        setupConstraints()
    }
}

// MARK: - BUTTON ACTIONS
extension MarketCartView: InfoPopUpShowable, LoadingShowable, DecisionPopUpShowable {
    @objc func buyButtonTapped() {
        showInfoPopUp(message: "Your order has been placed successfully! Thank You!") { [weak self] in
            guard let self = self else { return }
            showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self = self else { return }
                presenter.didTapBuyButton()
            }
        }
    }
    
    @objc func trashButtonTapped() {
        showDecisionPopUp(
            message: "Are you sure you want to delete all items from the cart?") { [weak self] in
            guard let self = self else { return }
                presenter.didTapTrashButton()
        } cancel: {}
    }
}

// MARK: - VIEW SETUP
extension MarketCartView {
    private func setupViews() {
    
        view.addSubview(collectionView)
        bottomBlock.addSubview(buyButton)
        bottomBlock.addSubview(priceLabel)
        view.addSubview(bottomBlock)
        presenter.updateCartStatus()
        navigationItem.rightBarButtonItem = trashButton
    }
    
    private func setupConstraints() {
        setupCollectionViewConstraints()
        setupBottomBlockConstraints()
        setupBuyButtonConstraints()
        setupPriceLabelConstraints()
    }
    
    private func setupBottomBlockConstraints() {
        bottomBlock.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupBuyButtonConstraints() {
        buyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-128)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    private func setupPriceLabelConstraints() {
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(buyButton.snp.trailing)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(buyButton.snp.top)
            make.bottom.equalTo(buyButton.snp.bottom)
        }
    }
    
    private func setupCollectionViewConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bottomBlock.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return sectionIndex == 0 ? CollectionViewLayouts.cartProductSection() :
            CollectionViewLayouts.suggestedProductSection()
        }
        layout.register(SectionBackground.self,
                        forDecorationViewOfKind: "defaultBackgroundElementKind")
        return layout
    }
}

// MARK: - COLLECTION VIEW DELEGATE
extension MarketCartView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectCartProduct(at: indexPath.item)
    }
}

// MARK: - COLLECTION VIEW DATA SOURCE
extension MarketCartView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return presenter.getCartProductCount()
        }
        return presenter.getSuggestedProductCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let productView = collectionView.dequeueReusableCell(
                withReuseIdentifier: CartProductView.identifier, for: indexPath) as! CartProductView
            let product = presenter.getCartProduct(at: indexPath.item)
            let cartProductInteractor = CartProductInteractor()
            let cartProductPresenter = CartProductPresenter(view: productView,
                                                            interactor: cartProductInteractor,
                                                            product: product)
            cartProductInteractor.output = cartProductPresenter
            productView.presenter = cartProductPresenter
            cartProductPresenter.cartUpdateDelegate = self
            productView.configure(with: product)
            return productView
        }
        
        let suggestedProductView = collectionView.dequeueReusableCell(
            withReuseIdentifier: SuggestedProductView.identifier,
            for: indexPath) as! SuggestedProductView
        suggestedProductView.configure(product: presenter.getSuggestedProduct(at: indexPath.item))
        suggestedProductView.cartUpdateDelegate = self
        return suggestedProductView
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "CustomHeaderView",
            for: indexPath) as! MarketCartHeaderView
        if indexPath.section == 0 {
            headerView.configureUILabel(
                titleText: "Current Address: " + presenter.getCurrentAddress(),
                backgroundColor: UIColor.white)
        }
        else {
            headerView.configureUILabel(titleText: "Suggested Products",
                                        backgroundColor: UIColor.marketLightOrange)
        }
        
        return headerView
    }
}

// MARK: - PROTOCOL METHODS
extension MarketCartView: MarketCartViewProtocol {
    func updatePriceLabel(price: Double) {
        priceLabel.text = String(format: "$%.2f", price)
    }
    
    func deleteItems(at indexPaths: [IndexPath]) {
        self.collectionView.deleteItems(at: indexPaths)
    }
    
    func insertItems(at indexPaths: [IndexPath]) {
        self.collectionView.insertItems(at: indexPaths)
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
}

extension MarketCartView: CartUpdateDelegate {
    func updateCart() {
        presenter.updateCartStatus()
    }
}
