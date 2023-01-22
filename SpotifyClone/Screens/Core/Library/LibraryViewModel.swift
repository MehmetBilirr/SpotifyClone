//
//  LibraryViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 20.01.2023.
//

import Foundation
import UIKit

protocol LibraryViewModelInterface:AnyObject {
  var view:LibraryViewInterface?{get set}
  func viewDidLoad()
  func fetchData()
  func cellForRowAt(_ indexPath:IndexPath,_ tableView:UITableView)->UITableViewCell
  func numberOfRowsInSection()->Int
  func didSelectRowAt(indexPath:IndexPath)
}


class LibraryViewModel {

  weak var view: LibraryViewInterface?
  private let apiManager:APIManager
  var tracks = [Track]()
  var albums = [Album]()
  init(view:LibraryViewInterface,apiManager:APIManager=APIManager.shared){
    self.view = view
    self.apiManager = apiManager
  }
}

extension LibraryViewModel:LibraryViewModelInterface{


  func viewDidLoad() {


    view?.configureSectionButtons()
    view?.configureTableView()
    view?.fetchData()
    

  }

  func fetchData() {


    var savedTracksResponse:SavedTracksResponse?
    var savedAlbumResponse:SavedAlbumsResponse?

    let group = DispatchGroup()

    //User Artist TopTracks
    group.enter()

    apiManager.getUserSavedTracks { result in
      switch result {

      case .success(let tracks):
        savedTracksResponse = tracks
      case .failure(let error):
        print(error)
      }
      group.leave()
    }
    //Artist Albums
    group.enter()
    apiManager.getUserSavedAlbums { result in
      switch result {

      case .success(let albums):
        savedAlbumResponse = albums
      case .failure(let error):
        print(error)
      }
      group.leave()
    }


    group.notify(queue: .main) {
      guard let tracks = savedTracksResponse?.items,
            let albums = savedAlbumResponse?.items
      else { return }
      self.tracks = tracks.map({$0.track})
      self.albums = albums.map({$0.album})
      self.view?.reloadData()
    }

  }

  func cellForRowAt(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
    
    if  view?.selectedIndex == 0 {
      cell.configure(content: .track(tracks[indexPath.row]))
    }else if view?.selectedIndex == 1 {
      cell.configure(content: .album(albums[indexPath.row]))
    }

    return cell
    
  }

  func numberOfRowsInSection() -> Int {
    if view?.selectedIndex == 0 {
      return tracks.count
    }else if view?.selectedIndex == 1{
      return albums.count
    }else {
    return 0
    }
  }

  func didSelectRowAt(indexPath: IndexPath) {

    if view?.selectedIndex == 0 {
      view?.goToViewControllers(content: .track(tracks[indexPath.row]))
    }else if view?.selectedIndex == 1{
      view?.goToViewControllers(content: .album(albums[indexPath.row]))
    }

  }
}
