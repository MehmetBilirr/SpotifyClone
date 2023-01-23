//
//  CategoryViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 12.01.2023.
//

import UIKit

protocol CategoryViewInterface:AnyObject {
  func configureCollectionView()
  func fetchData()
  func reloadData()
  func pushToContentDetail(content:ContentType)
}

class CategoryViewController: UIViewController {
  var category:Category?
  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
    return self?.collectionView.categorySectionLayout(section: sectionIndex)

  })
  lazy var viewModel = CategoryViewModel(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      viewModel.viewDidLoad()
      
    }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
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


extension CategoryViewController:CategoryViewInterface {

  func configureCollectionView() {
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
  }

  func fetchData() {
    guard let category = category else{return}
    viewModel.fetchData(category: category)
  }
  func reloadData() {
    collectionView.reloadData()
  }
  func pushToContentDetail(content: ContentType) {
    let vc = ContentDetailsViewController(content: content)
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension CategoryViewController:UICollectionViewDelegate,UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItemsIn()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    viewModel.cellForItemAt(indexPath, collectionView)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItemAt(indexPath)
  }

}
