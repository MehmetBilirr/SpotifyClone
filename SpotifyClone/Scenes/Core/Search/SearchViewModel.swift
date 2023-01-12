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

}


class SearchViewModel{
  weak var view: SearchViewInterface?
  let apiManager:APIManager?
  var categories = [Category]()
  init(view:SearchViewInterface,apiManager:APIManager = APIManager.shared){
    self.view = view
    self.apiManager = apiManager
  }

}

extension SearchViewModel:SearchViewModelInterface{

  func viewDidLoad() {
    view?.configureCollectionView()
    view?.fetchData()
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

}
