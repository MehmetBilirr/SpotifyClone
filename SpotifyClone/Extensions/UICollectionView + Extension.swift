//
//  UICollectionView + Extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 7.01.2023.
//

import Foundation
import UIKit

extension UICollectionView {


  func artistSectionLayout(section:Int)->NSCollectionLayoutSection{

    switch section {

      //Tracks
    case 0:

      let sectionBoundaryItem = [NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1),
              heightDimension: .absolute(300)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top) ]


      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1)))
      item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 2, bottom: 6, trailing: 2)
      //Group
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitem: item, count: 1)

      //Section
      let section = NSCollectionLayoutSection(group: verticalGroup)
      section.boundarySupplementaryItems = sectionBoundaryItem
      return section


      //Albums
    default:

      let sectionBoundaryItem = [NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1),
              heightDimension: .absolute(30)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top) ]

      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
      //Group


      //vertical
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(200)), subitem: item, count: 1)


      //horizontal
      let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200)), subitem: verticalGroup, count: 2)


      //Section

      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.orthogonalScrollingBehavior = .continuous
      section.boundarySupplementaryItems = sectionBoundaryItem
      return section

    }

  }

  func categorySectionLayout(section:Int)->NSCollectionLayoutSection{

    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    //Group


    //vertical
    let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(200)), subitem: item, count: 1)


    //horizontal
    let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitem: verticalGroup, count: 2)

    //Section
    let section = NSCollectionLayoutSection(group: horizontalGroup)
    return section
  }

  func searchSectionLayout(section:Int)->NSCollectionLayoutSection{

    switch section {
    default:
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1)))
      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
      //Group
      let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.17)), subitem: item, count: 2)

      //Section
      let section = NSCollectionLayoutSection(group: horizontalGroup)

      return section
    }
  }
func contentDetailSectionLayout(section:Int)->NSCollectionLayoutSection{

    let sectionBoundaryItem = [NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.4)),
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top) ]

    switch section {
    default:
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1)))
      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
      //Group
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitem: item, count: 1)

      //Section
      let section = NSCollectionLayoutSection(group: verticalGroup)
      section.boundarySupplementaryItems = sectionBoundaryItem
      return section
    }
  }

  func homeSectionLayout(section:Int)-> NSCollectionLayoutSection{

    let sectionBoundaryItem = [NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)),
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top) ]

    switch section {


    //User recently
    case 0:

      //Item
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
      //Group


      //vertical
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(220)), subitem: item, count: 3)


      //horizontal
      let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220)), subitem: verticalGroup, count: 2)

      //Section

      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.orthogonalScrollingBehavior = .groupPaging
      section.boundarySupplementaryItems = sectionBoundaryItem
      return section

    default:

      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
      //Group


      //vertical
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(200)), subitem: item, count: 1)


      //horizontal
      let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200)), subitem: verticalGroup, count: 2)


      //Section

      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.orthogonalScrollingBehavior = .continuous
      section.boundarySupplementaryItems = sectionBoundaryItem
      return section

    }
  }

}
