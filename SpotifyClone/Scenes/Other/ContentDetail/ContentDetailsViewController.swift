//
//  AlbumDetailsViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import UIKit

protocol ContentDetailsViewInterface:AnyObject {
  var viewModel:ContentDetailsViewModel{get set}
  func configureCollectionView()
  func fetchData()
  func reloadData()
  func configureShareButton()

}

class ContentDetailsViewController: UIViewController {
  var chosenAlbum:Album?
  var chosenPlaylist:Playlist?
  var item:DetailItemType?
  lazy var viewModel = ContentDetailsViewModel(view: self)

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

  @objc private func didTapShare() {

    switch item {
    case .album(let album):
      guard let url = URL(string: album.externalUrls.spotify) else {return}
      activityView(url: url)
    case .playlist(let playlist):
      guard let url = URL(string: playlist.externalUrls.spotify) else {return}
      activityView(url: url)
    default:
      break
    }
  }

  private func activityView(url:URL){
    let vc = UIActivityViewController(
        activityItems: [url],
        applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }


}

extension ContentDetailsViewController:ContentDetailsViewInterface {

  func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(ContentetailsCollectionViewCell.self, forCellWithReuseIdentifier: ContentetailsCollectionViewCell.identifier)
    collectionView.register(ContentHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:ContentHeaderCollectionReusableView.identifier )
  }

  func fetchData() {
    guard let item = item else {return}
    viewModel.fetchData(item: item)
    
  }
  func reloadData() {
    collectionView.reloadData()
  }
  func configureShareButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .action,
        target: self,
        action: #selector(didTapShare))
  }

}

extension ContentDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource {
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
