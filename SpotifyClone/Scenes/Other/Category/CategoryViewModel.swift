//
//  CategoryViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 12.01.2023.
//

import Foundation
import UIKit

protocol CategoryViewModelInterface:AnyObject {
  var view:CategoryViewInterface?{get set}
  func viewDidLoad()
  func fetchData()
  func cellForItemAt(_ indexPath:IndexPath,_ collectionView:UICollectionView)->UICollectionViewCell
  func numberOfItemsIn()->Int

}


class CategoryViewModel{
  weak var view: CategoryViewInterface?
  let apiManager:APIManager?
  var categories = [Category]()
  init(view:CategoryViewInterface,apiManager:APIManager = APIManager.shared){
    self.view = view
    self.apiManager = apiManager
  }

}

extension CategoryViewModel:CategoryViewModelInterface{

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
