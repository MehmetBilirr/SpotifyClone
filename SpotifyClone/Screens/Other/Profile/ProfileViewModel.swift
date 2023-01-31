//
//  ProfileViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import Foundation
import UIKit

protocol ProfileViewModelInterface:AnyObject {
  var view:ProfileViewInterface?{get set}
  func viewDidLoad()
  func fetchData()

  func numberOfSections()->Int
  func cellForItemAt(collectionView:UICollectionView,indexPath:IndexPath)->UICollectionViewCell
  func numberOfItemsInSection(section:Int)->Int
  func configureHeaderView(kind:String,collectionView:UICollectionView,indexPath:IndexPath)->UICollectionReusableView
  func didSelectRowAt(indexPath:IndexPath)


}


final class ProfileViewModel {


  weak var view: ProfileViewInterface?
  var profile:UserProfile?
  var playlists:[Playlist]?
  var rows = [String]()
  private let apiManager : APIManager

  init(view:ProfileViewInterface,ApiManager:APIManager = APIManager.shared){
    self.view = view
    self.apiManager = ApiManager
  }

  }


extension ProfileViewModel:ProfileViewModelInterface {



  func viewDidLoad() {
    view?.style()
    view?.layout()
    view?.configureTableView()
    view?.fetchData()


  }
  func fetchData() {
    let group = DispatchGroup()
    var user:UserProfile?
    var playlistResponse:PlaylistResponse?

    group.enter()
    apiManager.getCurrentUserProfile { result in
      switch result {
      case .success(let userProfile):
        user = userProfile
        self.view?.reloadData()
      case .failure(let error):
        self.view?.failedToGetProfile()
        print(error.localizedDescription)
      }
      group.leave()
    }

    group.enter()
    apiManager.getUserPlaylist { result in
      switch result {

      case .success(let playlists):
        playlistResponse = playlists
      case .failure(let error ):
        print(error.localizedDescription)
      }
      group.leave()
    }


    group.notify(queue: .main) {
      guard let user = user,
            let playlists = playlistResponse?.items
      else { return}
      self.configure(user: user, playlists: playlists)

    }
  }


  private func configure(user:UserProfile,playlists:[Playlist]) {
    self.profile = user
    self.playlists = playlists
    view?.reloadData()
  }


  func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    guard let playlist = playlists?[indexPath.row] else {return UICollectionViewCell()}
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
    cell.configure(playlist: playlist)
    return cell
  }

  func configureHeaderView(kind: String, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {

    guard let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
        for: indexPath) as? ProfileHeaderCollectionReusableView,
          kind == UICollectionView.elementKindSectionHeader else {
        return UICollectionReusableView()
    }
    header.configure(user: profile ?? .init(country: "", display_name: "", email: "", external_urls: .init(spotify: ""), id: "", product: "", images: [], followers: .init(total: 0)))

    return header
  }

  func numberOfSections() -> Int {
    return 1
  }

  func numberOfItemsInSection(section: Int) -> Int {
    return  playlists?.count ?? 0
  }

  func didSelectRowAt(indexPath: IndexPath) {

  }
}
