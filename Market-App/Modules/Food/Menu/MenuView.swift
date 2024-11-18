//
//  MenuView.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

import UIKit

protocol MenuViewProtocol: AnyObject {
    func setPrice(price: Double)
    func scrollToEmptyOption(option: Int)
    func showCompletedOrder()
}

class MenuView: UIViewController {
    var presenter: MenuPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuOptionCell.self,
                                forCellWithReuseIdentifier: MenuOptionCell.identifier)
        collectionView.register(
            FoodHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FoodHeaderView.identifier)
        collectionView.register(MenuHeaderView.self,
                                forSupplementaryViewOfKind: "MenuHeader",
                                withReuseIdentifier: MenuHeaderView.identifier)
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
        button.backgroundColor = .marketRed
        button.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Complete Order", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .marketRed
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "$0,00"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
// MARK: - VIEW CYCLES
extension MenuView {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .marketRed
        setupViews()
        setupConstraints()
    }
}

// MARK: - BUTTON ACTIONS
extension MenuView {
    @objc private func buyButtonTapped() {
        presenter.didTapBuyButton()
    }
}

// MARK: - SETUP VIEWS
extension MenuView {
    private func setupViews() {
        view.addSubview(collectionView)
        bottomBlock.addSubview(buyButton)
        bottomBlock.addSubview(priceLabel)
        view.addSubview(bottomBlock)
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
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return CollectionViewLayouts.menuSection(for: sectionIndex)
        }
        layout.register(FoodCollectionBackground.self,
                        forDecorationViewOfKind: "foodBackgroundElementKind")
        return layout
    }
}

// MARK: - PROTOCOL METHODS
extension MenuView: MenuViewProtocol, InfoPopUpShowable, LoadingShowable {
    func showCompletedOrder() {
        showInfoPopUp(message: "Your order has been placed successfully! Thank You!") { [weak self] in
            guard let self = self else { return }
            showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self = self else { return }
                presenter.navigateToHome()
            }
        }
    }
    
    func scrollToEmptyOption(option: Int) {
        collectionView.scrollToItem(at: IndexPath(
            item: 0, section: option), at: .centeredVertically, animated: true)
        let menuOption = presenter.getMenuOption(at: option)
        let options = menuOption.options.count
        for i in 0..<options {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: option)) as! MenuOptionCell
            cell.setWarning()
        }
    }
    
    func setPrice(price: Double) {
        priceLabel.text = String(format: "$%.2f", price)
    }
}

// MARK: - COLLECTION VIEW DATA SOURCE
extension MenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getMenuOption(at: section).options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuOptionCell.identifier, for: indexPath) as! MenuOptionCell
        cell.configure(with: presenter.getMenuOption(at: indexPath.section), label: presenter.getMenuOption(at: indexPath.section).options[indexPath.item])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.getMenuOptionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 && kind == "MenuHeader" {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MenuHeaderView.identifier,
                for: indexPath
            ) as! MenuHeaderView
            header.configure(with: presenter.getMenu())
            return header
        } else if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FoodHeaderView.identifier,
                for: indexPath
            ) as! FoodHeaderView
            header.configure(with: presenter.getMenuOption(at: indexPath.section).title)
            return header
        }
        
        fatalError("Unexpected element kind: \(kind)")
    }
}

// MARK: - COLLECTION VIEW DELEGATE
extension MenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<presenter.getMenuOption(at: indexPath.section).options.count {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: indexPath.section)) as! MenuOptionCell
            cell.setNonSelected()
            presenter.getMenuOption(at: indexPath.section).selectedOptionIndex = -1
        }
        let cell = collectionView.cellForItem(at: indexPath) as! MenuOptionCell
        presenter.getMenuOption(at: indexPath.section).selectedOptionIndex = indexPath.item
        cell.setSelected()
    }
}


