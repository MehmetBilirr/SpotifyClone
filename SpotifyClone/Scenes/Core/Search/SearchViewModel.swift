//
//  SearchViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 12.01.2023.
//

import Foundation
import UIKit

protocol SearchViewModelInterface:AnyObject {
  var view:SearchViewInterface?{get set}
  func viewDidLoad()
  func fetchData()
  func cellForItemAt(_ indexPath:IndexPath,_ collectionView:UICollectionView)->UICollectionViewCell
  func numberOfItemsIn()->Int
  func didSelectItemAt(_ indexPath:IndexPath)
  func search(query:String,searchController:UISearchController)

}


class SearchViewModel{
  weak var view: SearchViewInterface?
  let apiManager:APIManager?
  var categories = [Category]()
  var searchResults = [ContentType]()
  init(view:SearchViewInterface,apiManager:APIManager = APIManager.shared){
    self.view = view
    self.apiManager = apiManager
  }

}

extension SearchViewModel:SearchViewModelInterface{

  func viewDidLoad() {
    view?.configureCollectionView()
    view?.fetchData()
    view?.configureSearchController()
  }

  func fetchData() {
    apiManager?.getAllCategories(completion: { result in
      switch result {

      case .success(let categories):
        self.categories = categories.categories.items
        self.view?.reloadData()
      case .failure(let error):
        print(error.localizedDescription)
      }
    })
  }

  func cellForItemAt(_ indexPath: IndexPath, _ collectionView: UICollectionView) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
    cell.configure(category: categories[indexPath.row])
    return cell
  }

  func numberOfItemsIn() -> Int {
    return categories.count
  }

  func didSelectItemAt(_ indexPath: IndexPath) {
    view?.pushToView(category: categories[indexPath.row])
  }

  func search(query: String,searchController:UISearchController) {
    guard let resultController = searchController.searchResultsController as? SearchResultViewController else {return}
    apiManager?.search(query: query, completion: { result in
      switch result {

      case .success(let data):

        self.searchResults.append(contentsOf: data.albums.items.compactMap({ .album($0)}))
        self.searchResults.append(contentsOf: data.tracks.items.compactMap({.track($0)}))
        self.searchResults.append(contentsOf: data.artists.items.compactMap({.artist($0)}))
        self.searchResults.append(contentsOf: data.playlists.items.compactMap({.playlist($0)}))

        resultController.searchResults = self.searchResults
        resultController.tableView.reloadData()

      case .failure(let error):
        print(print(error.localizedDescription))
      }
    })
  }
}
