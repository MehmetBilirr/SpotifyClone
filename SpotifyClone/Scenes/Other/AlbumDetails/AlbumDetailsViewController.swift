//
//  AlbumDetailsViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import UIKit

protocol AlbumDetailsViewInterface:AnyObject {
  func configureCollectionView()

}

class AlbumDetailsViewController: UIViewController {
  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.albumDetailSectionLayout(section: sectionIndex)

  })
    override func viewDidLoad() {
        super.viewDidLoad()
      configureCollectionView()

    }

  override func viewDidLayoutSubviews() {
    view.addSubview(collectionView)
    collectionView.frame = view.bounds
  }


}

extension AlbumDetailsViewController:AlbumDetailsViewInterface {
  func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
  }


}

extension AlbumDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    20
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .blue
    return cell
  }


}
