//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import UIKit
import SnapKit
import SDWebImage

protocol ProfileViewInterface:AnyObject {
  func configureTableView()
  func fetchData()
  func reloadData()
  func style()
  func layout()
  func failedToGetProfile()

}

class ProfileViewController: UIViewController {
  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.profileSectionLayout(section: sectionIndex)

  })
  private lazy var viewModel = ProfileViewModel(view: self)
  private let logOutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
      viewModel.viewDidLoad()
    }


}


extension ProfileViewController:ProfileViewInterface {

  func style() {

    logOutButton.configureStyleTitleButton(title:"Log Out", titleColor: .black, backgroundClr: .white.withAlphaComponent(0.9),cornerRds: logOutButton.frame.height / 2)
    logOutButton.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)


    
  }

  @objc func didTapLogOut(){

    AuthManager.shared.signOut { [weak self] success in
        if success {
            DispatchQueue.main.async {
                let navC = UINavigationController(rootViewController: WelcomeViewController())
                navC.navigationBar.prefersLargeTitles = true
                navC.modalPresentationStyle = .fullScreen
                self?.present(navC, animated: true, completion: {
                    self?.navigationController?.popToRootViewController(animated: true)
                })

            }
        }}
  }

  func layout() {


    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.bottom.equalTo(-200)
    }

    view.addSubview(logOutButton)

    logOutButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(collectionView.snp.bottom).offset(20)
      make.height.equalTo(50)
      make.width.equalTo(100)

    }
  }

  func configureTableView() {
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
    collectionView.register(ProfileHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)

  }

  func fetchData() {
    viewModel.fetchData()
  }


  func reloadData() {
      self.collectionView.reloadData()

  }
   func failedToGetProfile() {
      let label = UILabel(frame: .zero)
      label.text = "Failed to load profile"
      label.sizeToFit()
      label.textColor = .secondaryLabel
      view.addSubview(label)
      label.center = view.center
  }
}

extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItemsInSection(section: section)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    viewModel.cellForItemAt(collectionView: collectionView, indexPath: indexPath)
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    viewModel.configureHeaderView(kind: kind, collectionView: collectionView, indexPath: indexPath)

  }


}
