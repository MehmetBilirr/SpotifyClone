//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit

class HomeViewController: UIViewController {
  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.createSectionLayout(section: sectionIndex)

  })
    override func viewDidLoad() {
        super.viewDidLoad()

      navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage( systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings) )

      configureCollectionView()

    }


  @objc func didTapSettings() {
    let vc = SettingsViewController()
    vc.title = "Settings"
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }

  private func configureCollectionView(){
    view.addSubview(collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: "cell")

  }

  override func viewDidLayoutSubviews() {
    collectionView.frame = view.bounds
  }



}


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .blue
    return cell
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }



}


extension HomeViewController {



  func createSectionLayout(section:Int)-> NSCollectionLayoutSection{

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
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitem: item, count: 1)

      //Section
      let section = NSCollectionLayoutSection(group: verticalGroup)
      section.boundarySupplementaryItems = sectionBoundaryItem
      return section

    }
  }
}
