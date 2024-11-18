//
//  ProductListView.swift
//  Market-App
//
//  Created by Berke Parıldar on 12.11.2024.
//

import UIKit

protocol ProductListViewProtocol: AnyObject {
    func reloadData()
}

class ProductListView: UICollectionViewCell {
    
    static let identifier: String = "ProductListView"
    
    var presenter: ProductListPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: contentView.bounds,
                                              collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .white
        
        collectionView.register(ProductView.self,
                                forCellWithReuseIdentifier: ProductView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(collectionView)
    }
    
   
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return CollectionViewLayouts.productGridSection()
        }
        layout.register(SectionBackground.self, forDecorationViewOfKind: "backgroundElementKind")
        return layout
    }
}

extension ProductListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.getProductCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let productView = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductView.identifier, for: indexPath) as! ProductView
        let product = presenter.getProduct(at: indexPath.item)
        let productInteractor = ProductInteractor()
        let productPresenter = ProductPresenter(interactor: productInteractor,
                                                view: productView,
                                                product: product)
        productInteractor.output = productPresenter
        productView.presenter = productPresenter
        productPresenter.cartButtonDelegate = presenter.getCartButtonDelegate()
        productView.configure(product: product)
        return productView
    }
}

extension ProductListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter.getSelectProductDelegate()?
            .didTapProduct(product: presenter.getProduct(at: indexPath.item))
    }
}

extension ProductListView: ProductListViewProtocol {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
}
