//
//  CategoryViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 12.01.2023.
//

import UIKit

protocol CategoryViewInterface:AnyObject {
  var viewModel:CategoryViewModel{get set}
  func configureCollectionView()
  func fetchData()
  func reloadData()
}

class CategoryViewController: UIViewController {

  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.categorySectionLayout(section: sectionIndex)

  })
  internal lazy var viewModel = CategoryViewModel(view: self)
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


extension CategoryViewController:CategoryViewInterface {

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

extension CategoryViewController:UICollectionViewDelegate,UICollectionViewDataSource {
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
