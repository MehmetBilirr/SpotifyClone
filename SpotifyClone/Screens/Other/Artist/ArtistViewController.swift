//
//  ArtistViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 19.01.2023.
//

import UIKit

protocol ArtistViewInterface:AnyObject {
  func configureCollectionView()
  func reloadData()
  func fetchData()

}

class ArtistViewController: UIViewController {

  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.artistSectionLayout(section: sectionIndex)

  })
  var artist:Artist?
  lazy var viewModel = ArtistViewModel(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      viewModel.viewDidLoad()
    }

  init(artist:Artist){
    self.artist = artist
    super.init(nibName: nil, bundle: nil)
  }

  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  


  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.addSubview(collectionView)
    collectionView.frame = view.bounds
  }

}

extension ArtistViewController:ArtistViewInterface{

  func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(TracksCollectionViewCell.self, forCellWithReuseIdentifier: TracksCollectionViewCell.identifier)
    collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    collectionView.register(ArtistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ArtistHeaderCollectionReusableView.identifier)

  }

  func reloadData() {
    collectionView.reloadData()
  }

  func fetchData() {
    viewModel.fetchData(id: artist?.id ?? "")
  }


}


extension ArtistViewController:UICollectionViewDelegate,UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItemsInSections(section: section)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    viewModel.cellForItemAt(collectionView, indexPath)

  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    viewModel.configureHeaderView(kind: kind, collectionView: collectionView, indexPath: indexPath)


  }

}
