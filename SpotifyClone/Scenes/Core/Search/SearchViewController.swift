//
//  SearchViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit

protocol SearchViewInterface:AnyObject {
  var viewModel:SearchViewModel{get set}
  func configureCollectionView()
  func fetchData()
  func reloadData()
}

class SearchViewController: UIViewController {

  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.searchSectionLayout(section: sectionIndex)

  })
  internal lazy var viewModel = SearchViewModel(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      viewModel.viewDidLoad()
    }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
  }

}


extension SearchViewController:SearchViewInterface {

  func configureCollectionView() {
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
  }

  func fetchData() {
    viewModel.fetchData()
  }
}

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItemsIn()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    viewModel.cellForItemAt(indexPath, collectionView)
  }

  func reloadData() {
    collectionView.reloadData()
  }


}
