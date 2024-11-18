//
//  RestaurantView.swift
//  Market-App
//
//  Created by Berke Parıldar on 18.11.2024.
//

import UIKit

protocol RestaurantViewProtocol: AnyObject {
    
}

class RestaurantView: UIViewController {
    var presenter: RestaurantPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .marketLightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.identifier)
        collectionView.register(FoodHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: FoodHeaderView.identifier)
        collectionView.register(RestaurantHeaderView.self,
                                forSupplementaryViewOfKind: "RestaurantHeader",
                                withReuseIdentifier: RestaurantHeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
}

// MARK: - VIEW CYCLES
extension RestaurantView {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .marketRed
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - SETUP VIEWS
extension RestaurantView {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return CollectionViewLayouts.menuListSection(for: sectionIndex)
        }
        layout.register(FoodCollectionBackground.self,
                        forDecorationViewOfKind: "foodBackgroundElementKind")
        return layout
    }
}

// MARK: - PROTOCOL METHODS
extension RestaurantView: RestaurantViewProtocol {
    
}

// MARK: - COLLECTION VIEW DATASOURCE
extension RestaurantView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getMenuCount(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.identifier,
                                                      for: indexPath) as! MenuCell
        cell.configure(with: presenter.getMenusOfGroup(index: indexPath.section)[indexPath.item])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.getMenuGroupCount()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 && kind == "RestaurantHeader" {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RestaurantHeaderView.identifier,
                for: indexPath
            ) as! RestaurantHeaderView
            header.configure(with: presenter.getRestaurant())
            return header
        } else if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FoodHeaderView.identifier,
                for: indexPath
            ) as! FoodHeaderView
            header.configure(with: presenter.getMenuGroup(at: indexPath.section).title)
            return header
        }
        
        fatalError("Unexpected element kind: \(kind)")
    }
}

// MARK: - COLLECTION VIEW DELEGATE
extension RestaurantView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMenu(at: indexPath)
    }
}

