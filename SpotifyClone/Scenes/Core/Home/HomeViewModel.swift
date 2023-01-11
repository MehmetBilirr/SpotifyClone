//
//  HomeViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//


import Foundation
import UIKit

enum BrowseSectionType {
  case newReleases([SpotifyModel.NewReleaseModel])
  case featuredPlaylists([SpotifyModel.PlaylistModel])
  case recommendedTracks([SpotifyModel.TrackModel])
}

protocol HomeViewModelInterface:AnyObject {
  var view:HomeViewInterface?{get set}
  func viewDidLoad()
  func fetchData()
  func numberOfSections()->Int
  func cellForItemAt(collectionView:UICollectionView,indexPath:IndexPath)->UICollectionViewCell
  func numberOfItemsInSection(section:Int)->Int
  func configureHeaderView(kind:String,collectionView:UICollectionView,indexPath:IndexPath)->UICollectionReusableView
  func didSelectRowAt(indexPath:IndexPath)

}

class HomeViewModel {
  weak var view: HomeViewInterface?
  private let apiManager : APIManager
  var sections = [BrowseSectionType]()
  var albums = [Album]()
  var playlists = [Playlist]()
  var tracks = [Track]()
  init(view:HomeViewInterface,apiManager:APIManager = APIManager.shared) {
    self.view = view
    self.apiManager = apiManager
  }
  

}


extension HomeViewModel:HomeViewModelInterface {
  func viewDidLoad() {
    view?.configureCollectionView()
    view?.configureNavBarItems()
    view?.fetchData()
    
  }

  func fetchData() {
    let group = DispatchGroup()


    var newReleases: NewReleasesResponse?
    var featuredPlaylists: FeaturedPlaylistsResponse?
    var recommendedTracks: RecommendationsResponse?
    //New  Releases
    group.enter()
    APIManager.shared.getReleases(completion: ) { result in

      switch result {
      case .success(let model):
        newReleases = model
      case .failure(let error):
        print(error.localizedDescription)
      }
      group.leave()
    }
    //FeaturedPlayLists
    group.enter()
    APIManager.shared.getFeaturedPlaylists { result in
        switch result {
        case .success(let model):
            featuredPlaylists = model

        case .failure(let error):
            print(error.localizedDescription)
        }
      group.leave()
    }
    //Recommended
    group.enter()
    APIManager.shared.getRecommendations { result in
      switch result {

      case .success(let model):
        recommendedTracks = model
      case .failure(let error):
        print(error.localizedDescription)
      }
      group.leave()
    }
    group.notify(queue: .main) {
        guard let releases = newReleases?.albums.items,
              let playlists = featuredPlaylists?.playlists.items,
              let tracks = recommendedTracks?.tracks
        else { return }

      self.apiManager.getAlbumDetails(albumID: releases.first?.id ?? "") { result in
        switch  result {

        case .success(let album):
          print(album)
        case .failure(let error):
          print(error)
        }
      }
      self.configureViewModels(newAlbums: releases,playlists: playlists,tracks: tracks)


    }
  }

  private func configureViewModels(newAlbums:[Album],playlists:[Playlist],tracks:[Track]) {
    self.albums = newAlbums
    self.playlists = playlists
    self.tracks = tracks
    sections.append(.newReleases(newAlbums.compactMap({
      .init(name: $0.name, image: $0.images.first?.url ?? "", numberOfTracks: $0.totalTracks, artistName: $0.artists.first?.name ?? "")
    })))

    sections.append(.featuredPlaylists(playlists.compactMap({
      .init(name: $0.name, image: $0.images.first?.url ?? "", creatorName: $0.owner.displayName)
    })))

    sections.append(.recommendedTracks(tracks.compactMap({
      .init(name: $0.name, artistName: $0.artists.first?.name ?? "", image: $0.album?.images.first?.url ?? "")
    })))

    view?.reloadData()

  }

  func numberOfSections() -> Int {
    return sections.count
  }

  func cellForItemAt(collectionView:UICollectionView,indexPath: IndexPath) -> UICollectionViewCell {

    let section = sections[indexPath.section]

    switch section {

    case .newReleases(let albums):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as! NewReleasesCollectionViewCell
      cell.configure(album: albums[indexPath.row])
      return cell
    case .featuredPlaylists(let playlists):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturedPlaylistCollectionViewCell
      cell.configure(model: playlists[indexPath.row])
      return cell
    case .recommendedTracks(let tracks):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath) as! TracksCollectionViewCell
      cell.configure(track: tracks[indexPath.row])
      return cell
    }
  }

  func numberOfItemsInSection(section: Int) -> Int {
    let section = sections[section]

    switch section {

    case .newReleases(let albums):
      return albums.count
    case .featuredPlaylists(let playlists):
      return playlists.count
    case .recommendedTracks(let tracks):
      return tracks.count
    }
  }

  func configureHeaderView(kind: String, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: HomeHeadersCollectionReusableView.identifier,
        for: indexPath) as? HomeHeadersCollectionReusableView,
          kind == UICollectionView.elementKindSectionHeader else {
        return UICollectionReusableView()
    }
    let type = sections[indexPath.section]
    switch type {

    case .newReleases(_):
      header.configure(with: "New Releases")
    case .featuredPlaylists:
      header.configure(with: "Featured Playlists")
    case .recommendedTracks:
      header.configure(with: "Recommended Tracks")
    }
    return header

  }

  func didSelectRowAt(indexPath: IndexPath) {

    let section = sections[indexPath.section]

    switch section {

    case .newReleases:
      view?.pushToAlbumDetailsVC(album: albums[indexPath.row])
    case .featuredPlaylists:
      return
    case .recommendedTracks:
      return
    }
  }


}
