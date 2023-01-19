//
//  SearchViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit
import SafariServices

protocol SearchViewInterface:AnyObject {
  var viewModel:SearchViewModel{get set}
  var isActive: Bool {get}
  func configureCollectionView()
  func fetchData()
  func reloadData()
  func pushToCategoryView(category:Category)
  func configureSearchController()
  func didTapContent(content:ContentType)

}

class SearchViewController: UIViewController {

  private lazy var  collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
    return self.collectionView.searchSectionLayout(section: sectionIndex)

  })

  let searchController = UISearchController(searchResultsController: SearchResultViewController())
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
  var isActive: Bool {
    return searchController.isActive
  }

  func configureCollectionView() {
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
  }

  func fetchData() {
    viewModel.fetchData()
  }
  func configureSearchController() {
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    searchController.searchBar.placeholder = "What do you want listen to?"
  }

  func didTapContent(content: ContentType) {
    pushToDetailView(content: content)
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItemAt(indexPath)
  }

  func pushToCategoryView(category: Category) {
    let vc = CategoryViewController()
    vc.category = category
    navigationController?.pushViewController(vc, animated: true)
  }

  func pushToDetailView(content:ContentType){
    switch content {
    case .artist(let artist):
      let vc = ArtistViewController(artist: artist)
      navigationController?.pushViewController(vc, animated: true)

    case.track(let track):
      let vc = PlayerViewController(track: track)
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: true)
    default:
      let vc = ContentDetailsViewController(content: content)
      navigationController?.pushViewController(vc, animated: true)
    }
  }

}


extension SearchViewController:UISearchResultsUpdating, UISearchBarDelegate{
  func updateSearchResults(for searchController: UISearchController) {
    guard let resultController = searchController.searchResultsController as? SearchResultViewController else {return}
    resultController.viewModel.delegate = self
    guard let text = searchController.searchBar.text,!text.trimmingCharacters(in: .whitespaces).isEmpty,text.trimmingCharacters(in: .whitespaces).count >= 3 else {return}
    viewModel.search(query: text, searchController: searchController)
  }

}
