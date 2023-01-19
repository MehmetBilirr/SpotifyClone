//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit

protocol HomeViewInterface:AnyObject {
  var viewModel:HomeViewModel{get set}
  func configureCollectionView()
  func configureNavBarItems()
  func fetchData()
  func reloadData()
  func pushToContentDetailsVC(item:ContentType)



  
}

class HomeViewController: UIViewController {

  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.homeSectionLayout(section: sectionIndex)

  })
  lazy var viewModel = HomeViewModel(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()

      viewModel.viewDidLoad()
      


    }


  override func viewDidLayoutSubviews() {
    collectionView.frame = view.bounds
  }

  private func pushNavigation(viewController:UIViewController){
    navigationController?.pushViewController(viewController, animated: true)
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

    

    collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)

    collectionView.register(TracksCollectionViewCell.self, forCellWithReuseIdentifier: TracksCollectionViewCell.identifier)

    collectionView.register(HomeHeadersCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeadersCollectionReusableView.identifier)

    collectionView.register(RecentlyPlayedCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyPlayedCollectionViewCell.identifier)

  }
  func fetchData() {
    viewModel.fetchData()
  }

  func reloadData() {  
    collectionView.reloadData()
  }
  func pushToContentDetailsVC(item:ContentType) {
    let vc = ContentDetailsViewController(content: item)
    navigationController?.pushViewController(vc, animated: true)

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

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectRowAt(indexPath: indexPath)
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



