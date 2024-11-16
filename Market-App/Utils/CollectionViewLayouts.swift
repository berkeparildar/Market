//
//  CollectionViewLayouts.swift
//  Market-App
//
//  Created by Berke Parıldar on 24.04.2024.
//

import UIKit

struct CollectionViewLayoutStyle {
    
    var itemSize: NSCollectionLayoutSize
    var groupSize: NSCollectionLayoutSize
    var groupCount: Int
    var interItemSpacing: NSCollectionLayoutSpacing
    var interGroupSpacing: CGFloat
    var sectionInset: NSDirectionalEdgeInsets
    var hasHeader: Bool
    var headerSize: NSCollectionLayoutSize
    var backgroundElementKind: String
    var scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    
    func createSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = groupCount != 0 ? NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitem: item, count: groupCount) : NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = interItemSpacing

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = sectionInset

        let sectionBackground = NSCollectionLayoutDecorationItem.background(
            elementKind: backgroundElementKind)
        section.decorationItems = [sectionBackground]

        if hasHeader {
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        section.orthogonalScrollingBehavior = scrollingBehavior
        return section
    }

    static let categoryStyle = CollectionViewLayoutStyle(
        itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .absolute(40)),
        groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .absolute(40)),
        groupCount: 1,
        interItemSpacing: .fixed(0),
        interGroupSpacing: 8,
        sectionInset: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        hasHeader: false,
        headerSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(16)),
        backgroundElementKind: "background-blue-element-kind",
        scrollingBehavior: .continuous
    ).createSection()
    
    static let productGroupStyle = CollectionViewLayoutStyle(
        itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1)),
        groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1)),
        groupCount: 1,
        interItemSpacing: .fixed(0),
        interGroupSpacing: 16,
        sectionInset: NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16),
        hasHeader: false,
        headerSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(16)),
        backgroundElementKind: "background-element-kind",
        scrollingBehavior: .groupPagingCentered
    ).createSection()

    static let productStyle = CollectionViewLayoutStyle(
        itemSize: NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(200)),
        groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)),
        groupCount: 3,
        interItemSpacing: .flexible(16),
        interGroupSpacing: 16,
        sectionInset: NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        hasHeader: false,
        headerSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(16)),
        backgroundElementKind: "background-element-kind",
        scrollingBehavior: .none
    ).createSection()
    
    static let tableStyle = CollectionViewLayoutStyle(
        itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102)),
        groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102)),
        groupCount: 0,
        interItemSpacing: .flexible(16),
        interGroupSpacing: 0,

        sectionInset: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        hasHeader: true,
        headerSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(48)),
        backgroundElementKind: "background-element-kind",
        scrollingBehavior: .none
    ).createSection()
    
    static let suggestedStyle = CollectionViewLayoutStyle(
        itemSize: NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .estimated(150)),
        groupSize: NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .estimated(150)),
        groupCount: 0,
        interItemSpacing: .fixed(0),
        interGroupSpacing: 16,
        sectionInset: NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        hasHeader: true,
        headerSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .estimated(48)),
        backgroundElementKind: "background-element-kind",
        scrollingBehavior: .continuous
    ).createSection()
}
