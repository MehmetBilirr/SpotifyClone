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
}

class ArtistViewController: UIViewController {
  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.contentDetailSectionLayout(section: sectionIndex)

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
  }

  func reloadData() {
    collectionView.reloadData()
  }
}


extension ArtistViewController:UICollectionViewDelegate,UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath)
    return cell
  }



}
