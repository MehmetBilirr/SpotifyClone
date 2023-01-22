//
//  ArtistViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 19.01.2023.
//

import Foundation
import UIKit

protocol ArtistViewModelInterface:AnyObject{
  var view:ArtistViewInterface?{get set}
  func viewDidLoad()
  func fetchData(artist: Artist)
  func numberOfSections()->Int
  func numberOfItemsInSections(section:Int)->Int
  func configureHeaderView(kind: String, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView
  func cellForItemAt(_ collectionView: UICollectionView,_ indexPath: IndexPath) -> UICollectionViewCell
  func didSelectItemAt(_ indexPath:IndexPath)

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
  var artist:Artist?
  init(view:ArtistViewInterface,apiManager:APIManager=APIManager.shared){
    self.view = view
    self.apiManager = apiManager
  }

}


extension ArtistViewModel:ArtistViewModelInterface {
  func viewDidLoad() {

    view?.configureCollectionView()
    view?.fetchData()
  

  }

  func fetchData(artist: Artist) {
    self.artist = artist
    var topTracksResponse:TopTracksResponse?
    var albumResponse:AlbumResponse?

    let group = DispatchGroup()

    //User Artist TopTracks
    group.enter()

    apiManager.getArtistTopTracks(id: artist.id) { result in
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
    apiManager.getArtistAlbums(id: artist.id) { result in
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
      self.configureSections(tracks: tracks, albums: albums)
      print(tracks)
    }

  }

  private func configureSections(tracks:[Track],albums:[Album]){
    self.tracks = tracks
    self.albums = albums

    sections.append(.topTracks(tracks))
    sections.append(.albums(albums))
    view?.reloadData()
  }

  func numberOfSections() -> Int {
    sections.count
  }

  func numberOfItemsInSections(section: Int) -> Int {
    let section = sections[section]
    switch section {

    case .topTracks(let tracks):
      return tracks.count
    case .albums(let albums):
      return albums.count
    }
  }

  func cellForItemAt(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
    let section = sections[indexPath.section]
    switch section {

    case .topTracks(let tracks):

      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath) as! TracksCollectionViewCell
      cell.configure(track: tracks[indexPath.row])
      return cell
    case .albums(let albums):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as! AlbumCollectionViewCell
      cell.configure(album: albums[indexPath.row])
      return cell

    }
  }
  func configureHeaderView(kind: String, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: ArtistHeaderCollectionReusableView.identifier,
        for: indexPath) as? ArtistHeaderCollectionReusableView,
          kind == UICollectionView.elementKindSectionHeader else {
        return UICollectionReusableView()
    }
    
    let type = sections[indexPath.section]
    switch type {

    case .topTracks(let tracks):
      header.configure(headerTitle: "Popular",artist: artist)
    case .albums:
      header.configure(headerTitle: "Albums")
    }
    return header
  }

  func didSelectItemAt(_ indexPath: IndexPath) {
    let section = sections[indexPath.section]
    switch section {

    case .topTracks(let tracks):
      view?.pushToView(content: .track(tracks[indexPath.row]))
    case .albums(let albums):
      view?.pushToView(content: .album(albums[indexPath.row]))
    }
  }


}
