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
  func fetchData(category:Category)
  func cellForItemAt(_ indexPath:IndexPath,_ collectionView:UICollectionView)->UICollectionViewCell
  func numberOfItemsIn()->Int
  func didSelectItemAt(_ indexPath:IndexPath)

}


final class CategoryViewModel{
  weak var view: CategoryViewInterface?
  let apiManager:APIManager?
  var playlists = [Playlist]()

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

  func fetchData(category:Category) {
    apiManager?.getCategoryPlaylists(categoryId: category.id, completion: { result in
      switch result {

      case .success(let category):
        self.playlists = category.playlists.items.compactMap({
          .init(itemDescription: "", externalUrls: $0.externalUrls, id: $0.id, images: $0.images, name: $0.name, owner: $0.owner)
        })

        self.view?.reloadData()
      case .failure(let error):
        print(error.localizedDescription)
      }
    })
  }

  func cellForItemAt(_ indexPath: IndexPath, _ collectionView: UICollectionView) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
    cell.configure(playlist: playlists[indexPath.row])
    return cell
  }

  func numberOfItemsIn() -> Int {
    return playlists.count
  }

  func didSelectItemAt(_ indexPath: IndexPath) {

    view?.pushToContentDetail(content: .playlist(playlists[indexPath.row]))
  }

}
