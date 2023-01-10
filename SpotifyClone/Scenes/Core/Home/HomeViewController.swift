//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit

enum BrowseSectionType {
    case newReleases
    case featuredPlaylists
    case recommendedTracks
}

class HomeViewController: UIViewController {
  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.browseSectionLayout(section: sectionIndex)

  })
  var sections : [BrowseSectionType] = [.newReleases,.featuredPlaylists,.recommendedTracks]
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
    collectionView.register( NewReleasesCollectionViewCell.self,
                             forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
    collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
    collectionView.register(TracksCollectionViewCell.self, forCellWithReuseIdentifier: TracksCollectionViewCell.identifier)

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
    let section = sections[indexPath.section]

    switch section {

    case .newReleases:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath)
      return cell
    case .featuredPlaylists:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath)
      return cell
    case .recommendedTracks:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath)
      return cell
    }
    }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }


}




