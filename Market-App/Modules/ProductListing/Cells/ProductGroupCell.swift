//
//  TrialCollectionViewCell.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.06.2024.
//

import UIKit

protocol ProductCellOwnerDelegate: AnyObject {
    func didTapAddButton(product: Product)
    func didTapRemoveButton(product: Product)
}

class ProductGroupCell: UICollectionViewCell {
    private var products: [Product] = []
    static let identifier: String = "groupCell"
    weak var delegate: GroupCellOwnerDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .white
        collectionView.register(ProductCellView.self, forCellWithReuseIdentifier: ProductCellView.identifier)
        collectionView.register(SectionBackground.superclass(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(collectionView)
    }
    
    func configure(products: [Product], delegate: GroupCellOwnerDelegate) {
        self.products = products
        self.delegate = delegate
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor)
        ])
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return CollectionViewLayoutStyle.productStyle
        }
        layout.register(SectionBackground.self, forDecorationViewOfKind: "background-element-kind")
        return layout
    }
}
extension ProductGroupCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCellView
        let product = products[indexPath.item]
        ProductCellBuilder.createModule(cellView: cellView, product: product, cellOwner: self)
        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderView", for: indexPath)
        headerView.backgroundColor = .marketLightGray
        return headerView
    }
}

extension ProductGroupCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectProduct(product: products[indexPath.item])
    }
}

extension ProductGroupCell: ProductCellOwnerDelegate {
    func didTapAddButton(product: Product) {
        delegate?.didTapAddButton(product: product)
    }
    func didTapRemoveButton(product: Product) {
        delegate?.didTapRemoveButton(product: product)
    }
}
