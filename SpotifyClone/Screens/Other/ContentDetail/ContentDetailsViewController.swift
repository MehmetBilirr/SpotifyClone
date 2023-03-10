//
//  AlbumDetailsViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import UIKit

protocol ContentDetailsViewInterface:AnyObject {

  func configureCollectionView()
  func fetchData()
  func reloadData()
  func configureShareButton()
  func pushToPlayer(track:Track)

}

final class ContentDetailsViewController: UIViewController {
  var chosenAlbum:Album?
  var chosenPlaylist:Playlist?
  var content:ContentType?
  lazy var viewModel = ContentDetailsViewModel(view: self)

  init(content:ContentType){
    self.content = content
    super.init(nibName: nil, bundle: nil)
  }


  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
    return self?.collectionView.contentDetailSectionLayout(section: sectionIndex)

  })
    override func viewDidLoad() {
        super.viewDidLoad()
      viewModel.viewDidLoad()

      
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

  @objc private func didTapShare() {

    switch content {
    case .album(let album):
      guard let url = URL(string: album.externalUrls.spotify) else {return}
      activityView(url: url)
    case .playlist(let playlist):
      guard let url = URL(string: playlist.externalUrls?.spotify ?? "") else {return}
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
    collectionView.register(TracksCollectionViewCell.self, forCellWithReuseIdentifier: TracksCollectionViewCell.identifier)
    collectionView.register(ContentHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:ContentHeaderCollectionReusableView.identifier )
  }

  func fetchData() {
    guard let content = content else {return}
    viewModel.fetchData(content: content)
    
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
    guard let item = content else {return UICollectionReusableView()}
    return viewModel.configureHeader(indexPath: indexPath, content: item, collectionView: collectionView, kind: kind)

    }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath) as! TracksCollectionViewCell
    viewModel.didSelectItemAt(indexPath)

  }

  func pushToPlayer(track:Track) {
    let trackID : String = track.id
    NotificationCenter.default.post(name: .trackNotification, object: trackID)
   

  }


}


