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
  func pushToView(content:ContentType)

}

final class ArtistViewController: UIViewController {

  private let artistImageView = UIImageView()
  private let artistName = UILabel()
  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
    return self?.collectionView.artistSectionLayout(section: sectionIndex)

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
    collectionView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.bottom.equalToSuperview().offset(-50 - (self.tabBarController?.tabBar.frame.height)!)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    view.isHidden = true
  }

  override func viewWillAppear(_ animated: Bool) {
    view.isHidden = false
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
    viewModel.fetchData(artist: artist ?? .init(externalUrls: .init(spotify: ""), id: "", name: "", type: "", images: []))
  }

  func pushToView(content: ContentType) {

    switch content {
    case .album(let album):
      navigationController?.pushViewController(ContentDetailsViewController(content: .album(album)), animated: true)
    case .track(let track):
      let trackID : String = track.id
      NotificationCenter.default.post(name: .trackNotification, object: trackID)
    default:
      break
  }
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItemAt(indexPath)
  }


}

