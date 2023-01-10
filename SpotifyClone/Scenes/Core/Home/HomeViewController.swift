//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit

protocol HomeViewInterface:AnyObject {
  func configureCollectionView()
  func configureNavBarItems()
  func fetchData()
  func reloadData()


  
}

class HomeViewController: UIViewController {

  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.browseSectionLayout(section: sectionIndex)

  })
  private lazy var viewModel = HomeViewModel(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()

      viewModel.viewDidLoad()


    }


  override func viewDidLayoutSubviews() {
    collectionView.frame = view.bounds
  }



}

extension HomeViewController:HomeViewInterface {
  func configureNavBarItems() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage( systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings) )
  }

  @objc func didTapSettings() {
    let vc = SettingsViewController()
    vc.title = "Settings"
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }

  func configureCollectionView(){
    view.addSubview(collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register( NewReleasesCollectionViewCell.self,
                             forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
    collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)

    collectionView.register(TracksCollectionViewCell.self, forCellWithReuseIdentifier: TracksCollectionViewCell.identifier)

    collectionView.register(HomeHeadersCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeadersCollectionReusableView.identifier)

  }
  func fetchData() {
    viewModel.fetchData()
  }

  func reloadData() {
    collectionView.reloadData()
  }

}


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItemsInSection(section: section)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    viewModel.cellForItemAt(collectionView: collectionView, indexPath: indexPath)
    }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections()
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    viewModel.configureHeaderView(kind: kind, collectionView: collectionView, indexPath: indexPath)


  }
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            let defaultOffset = view.safeAreaInsets.top
//
//            let offset = scrollView.contentOffset.y + defaultOffset
//            print(scrollView.contentOffset.y)
//
//
//            navigationController?.navigationBar.transform = .init(translationX: 0, y:min(0, -offset))
  }


}



