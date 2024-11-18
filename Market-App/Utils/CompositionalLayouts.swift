//
//  CollectionViewLayouts.swift
//  Market-App
//
//  Created by Berke Parıldar on 24.04.2024.
//

import UIKit

struct CollectionViewLayouts {
    
    static func productCategorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .absolute(40))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: .init(layoutSize: itemSize), count: 1)
        group.interItemSpacing = .fixed(0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .zero
        section.orthogonalScrollingBehavior = .continuous
        let sectionBackground = NSCollectionLayoutDecorationItem.background(
            elementKind: "categoryBackgroundElementKind")
        section.decorationItems = [sectionBackground]
        return section
    }
    
    static func productListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: .init(layoutSize: itemSize), count: 1)
        group.interItemSpacing = .fixed(0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let sectionBackground = NSCollectionLayoutDecorationItem.background(
            elementKind: "defaultBackgroundElementKind")
        section.decorationItems = [sectionBackground]
        return section
    }
    
    static func productGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(200))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: .init(layoutSize: itemSize), count: 3)
        group.interItemSpacing = .flexible(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        let sectionBackground = NSCollectionLayoutDecorationItem.background(
            elementKind: "backgroundElementKind")
        section.decorationItems = [sectionBackground]
        return section
    }
    
    static func cartProductSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: .init(layoutSize: itemSize), count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .zero
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(48)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        let sectionBackground = NSCollectionLayoutDecorationItem.background(
            elementKind: "defaultBackgroundElementKind")
        section.decorationItems = [sectionBackground]
        return section
    }
    
    static func suggestedProductSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .estimated(150))
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: .init(layoutSize: itemSize), count: 1)
        group.interItemSpacing = .fixed(0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .estimated(48)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        section.orthogonalScrollingBehavior = .continuous
        let sectionBackground = NSCollectionLayoutDecorationItem.background(
            elementKind: "defaultBackgroundElementKind")
        section.decorationItems = [sectionBackground]
        return section
    }
    
    static func foodCategoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .absolute(176))
        _ = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                               heightDimension: .absolute(192))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: .init(layoutSize: itemSize), count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let sectionBackground = NSCollectionLayoutDecorationItem.background(
            elementKind: "foodBackgroundElementKind")
        section.decorationItems = [sectionBackground]
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        return section
    }
    
    static func restaurantListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(112))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(112))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionBackground = NSCollectionLayoutDecorationItem.background(
            elementKind: "foodBackgroundElementKind")
        section.decorationItems = [sectionBackground]
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        return section
    }
    
    static func menuListSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(112))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(112))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        if sectionIndex == 0 {
            let largeHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(300)
                ),
                elementKind: "RestaurantHeader",
                alignment: .top
            )
            section.boundarySupplementaryItems = [largeHeader]
        } else {
            let defaultHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [defaultHeader]
        }
        
        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: "foodBackgroundElementKind")
        section.decorationItems = [sectionBackground]
        
        return section
    }
    
    static func menuSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        if sectionIndex == 0 {
            let largeHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(332)
                ),
                elementKind: "MenuHeader",
                alignment: .top
            )
            section.boundarySupplementaryItems = [largeHeader]
        } else {
            let defaultHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [defaultHeader]
        }
        
        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: "foodBackgroundElementKind")
        section.decorationItems = [sectionBackground]
        
        return section
    }
}
