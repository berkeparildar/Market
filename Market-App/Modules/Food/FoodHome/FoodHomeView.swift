//
//  FoodHomeView.swift
//  Market-App
//
//  Created by Berke Parıldar on 16.11.2024.
//

import UIKit

protocol FoodHomeViewProtocol: AnyObject {
    func reloadData()
}

class FoodHomeView: UIViewController {
    var presenter: FoodHomePresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .marketLightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RestaurantCategoryCell.self, forCellWithReuseIdentifier: RestaurantCategoryCell.identifier)
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: RestaurantCell.identifier)
        collectionView.register(FoodHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FoodHeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        var image = UIImage(systemName: "xmark")
        image = image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 14,
                                                                               weight: .bold))
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonTapped))
        return button
    }()
    
    private lazy var cartButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .marketLightGray
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var cartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart.fill")
        imageView.tintColor = .marketRed
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
        label.textColor = .marketRed
        label.textAlignment = .center
        label.text = "$0,00"
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
}

extension FoodHomeView {
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
}

// MARK: - VIEW CYCLES
extension FoodHomeView : LoadingShowable {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        showLoading()
        setupConstraints()
        presenter.fetchCategories()
        presenter.getRestaurants()
        view.backgroundColor = .marketRed
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButtonView)
    }
}
// MARK: - SETUP VIEWS
extension FoodHomeView {
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            if sectionIndex == 0 {
                return CollectionViewLayouts.foodCategoriesSection()
            } else {
                return CollectionViewLayouts.restaurantListSection()
            }
        }
        layout.register(FoodCollectionBackground.self,
                        forDecorationViewOfKind: "foodBackgroundElementKind")
        return layout
    }
}

// MARK: - PROTOCOL METHODS
extension FoodHomeView: FoodHomeViewProtocol {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
            hideLoading()
        }
    }
}

// MARK: - COLLECTION VIEW DATA SOURCE
extension FoodHomeView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? presenter.getCategoryCount() : presenter.getRestaurantCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCategoryCell.identifier, for: indexPath) as! RestaurantCategoryCell
            cell.configure(with: presenter.getCategory(at: indexPath.item))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RestaurantCell.identifier, for: indexPath) as! RestaurantCell
            cell.configure(with: presenter.getRestaurant(at: indexPath.item))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) ->
    UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FoodHeaderView.identifier, for: indexPath) as! FoodHeaderView
            header.configure(with: indexPath.section == 0 ? "Categories" : "All Restaurants")
            return header
        }
        return UICollectionReusableView()
    }
}

// MARK: - COLLECTION VIEW DELEGATE
extension FoodHomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            presenter.didTapCategory(at: indexPath.item)
        }
        else {
            presenter.didTapRestaurant(at: indexPath.item)
        }
    }
}
