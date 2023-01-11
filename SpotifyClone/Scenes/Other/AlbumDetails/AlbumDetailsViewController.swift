//
//  AlbumDetailsViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import UIKit

protocol AlbumDetailsViewInterface:AnyObject {
  var viewModel:AlbumDetailsViewModel{get set}
  func configureCollectionView()
  func fetchData()
  func reloadData()

}

class AlbumDetailsViewController: UIViewController {
  var chosenAlbum:Album?
  var chosenPlaylist:Playlist?
  var item:DetailItemType?
  lazy var viewModel = AlbumDetailsViewModel(view: self)

  init(item:DetailItemType){
    self.item = item
    super.init(nibName: nil, bundle: nil)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.albumDetailSectionLayout(section: sectionIndex)

  })
    override func viewDidLoad() {
        super.viewDidLoad()
      viewModel.viewDidLoad()

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
    collectionView.register(AlbumDetailsCollectionViewCell.self, forCellWithReuseIdentifier: AlbumDetailsCollectionViewCell.identifier)
    collectionView.register(AlbumHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:AlbumHeaderCollectionReusableView.identifier )
  }

  func fetchData() {
    guard let item = item else {return}
    viewModel.fetchData(item: item)
    
  }
  func reloadData() {
    collectionView.reloadData()
  }

}

extension AlbumDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.numberOfItemsInSection()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    viewModel.cellForItemAt(collectionView: collectionView, indexPath: indexPath)
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let item = item else {return UICollectionReusableView()}
    return viewModel.configureHeader(indexPath: indexPath, item: item, collectionView: collectionView, kind: kind)

    }

}
