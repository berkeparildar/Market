//
//  CollectionViewLayouts.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 24.04.2024.
//

import UIKit

/*
 This struct holds the four different compositional layout styles of the CollectionViews throught the application,
 with a function for creating and returning the section with the specified style. The horizontal style is used for
 the horizontal list of proructs in the Product Listing page, while the vertical style is used for the other vertical
 layout. The table style is for the Cart View, which is used for the collection of products in cart, and the suggested
 style is used for the horizontal collection in Cart View. The difference between the horizontal and suggested styles
 is the headers.
 */

struct CollectionViewLayoutStyle {
    
    var itemSize: NSCollectionLayoutSize
    var groupSize: NSCollectionLayoutSize
    var groupCount: Int
    var interItemSpacing: NSCollectionLayoutSpacing
    var interGroupSpacing: CGFloat
    var sectionInset: NSDirectionalEdgeInsets
    var hasHeader: Bool
    var headerSize: NSCollectionLayoutSize
    var scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior

    func createSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = groupCount != 0 ? NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupCount) : NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = interItemSpacing

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = sectionInset

        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: "background-element-kind")
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

    static let horizontalStyle = CollectionViewLayoutStyle(
        itemSize: NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .estimated(150)),
        groupSize: NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .estimated(150)),
        groupCount: 0,
        interItemSpacing: .fixed(0),
        interGroupSpacing: 16,
        sectionInset: NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        hasHeader: true,
        headerSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(16)),
        scrollingBehavior: .continuous
    ).createSection()

    static let verticalStyle = CollectionViewLayoutStyle(
        itemSize: NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(200)),
        groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)),
        groupCount: 3,
        interItemSpacing: .flexible(16),
        interGroupSpacing: 16,
        sectionInset: NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        hasHeader: true,
        headerSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(16)),
        scrollingBehavior: .none
    ).createSection()
    
    static let tableStyle = CollectionViewLayoutStyle(
        itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102)),
        groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102)),
        groupCount: 0,
        interItemSpacing: .flexible(16),
        interGroupSpacing: 0,

        sectionInset: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        hasHeader: false,
        headerSize: NSCollectionLayoutSize(widthDimension: .absolute(16), heightDimension: .absolute(16)),
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
        scrollingBehavior: .continuous
    ).createSection()
    
}
