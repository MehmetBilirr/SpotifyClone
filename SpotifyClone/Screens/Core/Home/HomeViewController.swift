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
  func pushToContentDetailsVC(content:ContentType)

}

final class HomeViewController: UIViewController {

  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
    return self?.collectionView.homeSectionLayout(section: sectionIndex)

  })
  lazy var viewModel = HomeViewModel(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()

      viewModel.viewDidLoad()


    }
  override func viewWillDisappear(_ animated: Bool) {
    view.isHidden = true
  }
  override func viewWillAppear(_ animated: Bool) {
    view.isHidden = false
  }


  override func viewDidLayoutSubviews() {
    collectionView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.top.equalToSuperview().offset(-50)
      make.bottom.equalToSuperview().offset(-50 - (self.tabBarController?.tabBar.frame.height)!)
    }
  }

  private func pushNavigation(viewController:UIViewController){
    navigationController?.pushViewController(viewController, animated: true)

  }
}

extension HomeViewController:HomeViewInterface {


  func configureNavBarItems() {
    let bellButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .done, target: self, action: nil)
    let historyButton = UIBarButtonItem(image: UIImage(systemName: "clock"), style: .done, target: self, action: nil)
    let gearButton = UIBarButtonItem(image: UIImage( systemName: "gearshape"), style: .done, target: self, action: #selector(didTapSettings))
    navigationItem.rightBarButtonItems = [gearButton,historyButton,bellButton]

    navigationItem.leftBarButtonItem = UIBarButtonItem(title:greetingLogic(), style: .done, target: self, action: nil)

  }

  @objc func didTapSettings() {
    let vc = ProfileViewController()
    vc.title = "Profile"
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
  func pushToContentDetailsVC(content:ContentType) {
    let vc = ContentDetailsViewController(content: content)
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
//    navigationController?.navigationBar.backgroundColor = .black
//
////            navigationController?.navigationBar.transform = .init(translationX: 0, y:min(0, -offset))
  }

  private func greetingLogic() -> String {
    let date = NSDate()
    let calendar = NSCalendar.current
    let currentHour = calendar.component(.hour, from: date as Date)
    let hourInt = Int(currentHour.description)!

    let NEW_DAY = 0
    let NOON = 12
    let SUNSET = 18
    let MIDNIGHT = 24

    var greetingText = "Hello" // Default greeting text
    if hourInt >= NEW_DAY && hourInt <= NOON {
        greetingText = "Good Morning"
    }
    else if hourInt > NOON && hourInt <= SUNSET {
        greetingText = "Good Afternoon"
    }
    else if hourInt > SUNSET && hourInt <= MIDNIGHT {
        greetingText = "Good Evening"
    }

    return greetingText
  }


}



