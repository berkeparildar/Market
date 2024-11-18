//
//  RestaurantListView.swift
//  Market-App
//
//  Created by Berke Parıldar on 17.11.2024.
//

import UIKit

protocol RestaurantListViewProtocol: AnyObject {
    func reloadData()
}

class RestaurantListView: UIViewController {
    var presenter: RestaurantListPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RestaurantCell.self,
                                forCellWithReuseIdentifier: RestaurantCell.identifier)
        collectionView.register(
            FoodHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FoodHeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
}

extension RestaurantListView {
    override func viewDidLoad() {
        view.backgroundColor = .marketRed
        super.viewDidLoad()
        presenter.getRestaurants()
        setupViews()
        title = "Restaurants"
        setupConstraints()
    }
}


// MARK: - SETUP VIEWS
extension RestaurantListView {
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
        let layout =  UICollectionViewCompositionalLayout { sectionIndex, environment in
            return CollectionViewLayouts.restaurantListSection()
        }
        layout.register(FoodCollectionBackground.self,
                        forDecorationViewOfKind: "foodBackgroundElementKind")
        return layout
    }
}

// MARK: - COLLECTION VIEW DATA SOURCE
extension RestaurantListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getRestaurantCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RestaurantCell.identifier, for: indexPath) as! RestaurantCell
        cell.configure(with: presenter.getRestaurantAt(index: indexPath.item))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FoodHeaderView.identifier, for: indexPath) as! FoodHeaderView
            header.configure(
                with: RestaurantService.shared.getCategories()[presenter.getId()].name
)
            return header
        }
        return UICollectionReusableView()
    }
}

// MARK: - COLLECTION VIEW DELEGATE
extension RestaurantListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapRestaurant(index: indexPath.item)
    }
}

extension RestaurantListView: RestaurantListViewProtocol {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
}


