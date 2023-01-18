//
//  ArtistViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 19.01.2023.
//

import Foundation


protocol ArtistViewModelInterface:AnyObject{
  var view:ArtistViewInterface?{get set}
  func viewDidLoad()
  func fetchData(id:String)
}




class ArtistViewModel {

  enum ArtistSectionType {
    case topTracks([Track])
    case albums([Album])
  }

  weak var view: ArtistViewInterface?
  private let apiManager : APIManager
  var sections = [ArtistSectionType]()
  var albums = [Album]()
  var tracks = [Track]()
  init(view:ArtistViewInterface,apiManager:APIManager=APIManager.shared){
    self.view = view
    self.apiManager = apiManager
  }

}


extension ArtistViewModel:ArtistViewModelInterface {
  func viewDidLoad() {

    view?.configureCollectionView()
  }

  func fetchData(id: String) {

    var topTracksResponse:TopTracksResponse?
    var albumResponse:AlbumResponse?

    let group = DispatchGroup()

    //User Artist TopTracks
    group.enter()

    apiManager.getArtistTopTracks(id: id) { result in
      switch result {

      case .success(let tracks):
        topTracksResponse = tracks
      case .failure(let error):
        print(error)
      }
      group.leave()
    }
    //Artist Albums
    group.enter()
    apiManager.getArtistAlbums(id: id) { result in
      switch result {

      case .success(let albums):
        albumResponse = albums
      case .failure(let error):
        print(error)
      }
      group.leave()
    }


    group.notify(queue: .main) {
      guard let tracks = topTracksResponse?.tracks,
            let albums = albumResponse?.items
      else { return }
    }
  }

  private func configureSections(tracks:[Track],albums:[Album]){
    self.tracks = tracks
    self.albums = albums

    sections.append(.topTracks(tracks))
    sections.append(.albums(albums))
  }

}
