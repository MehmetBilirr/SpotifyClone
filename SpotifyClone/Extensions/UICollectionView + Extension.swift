//
//  UICollectionView + Extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 7.01.2023.
//

import Foundation
import UIKit

extension UICollectionView {
  func browseSectionLayout(section:Int)-> NSCollectionLayoutSection{

    let sectionBoundaryItem = [NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(40)),
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top) ]

    switch section {
    case 0:

     
      //Item
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
      //Group


      //vertical
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(360)), subitem: item, count: 3)


      //horizontal
      let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(360)), subitem: verticalGroup, count: 1)

      //Section

      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.orthogonalScrollingBehavior = .groupPaging
      section.boundarySupplementaryItems = sectionBoundaryItem
      return section

    case 1:

      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
      //Group


      //vertical
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(200)), subitem: item, count: 1)


      //horizontal
      let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200)), subitem: verticalGroup, count: 2)


      //Section

      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.orthogonalScrollingBehavior = .groupPaging
      section.boundarySupplementaryItems = sectionBoundaryItem
      return section


    default:
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1)))
      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
      //Group
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70)), subitem: item, count: 1)

      //Section
      let section = NSCollectionLayoutSection(group: verticalGroup)
      section.boundarySupplementaryItems = sectionBoundaryItem
      return section

    }
  }

}
