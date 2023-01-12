//
//  HomeViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//


import Foundation
import UIKit

enum BrowseSectionType {
  case newReleases([SpotifyModel.AlbumModel])
  case featuredPlaylists([SpotifyModel.PlaylistModel])
  case userPlaylists([SpotifyModel.PlaylistModel])
  case recommendedTracks([SpotifyModel.TrackModel])
  case userRecently([SpotifyModel.PlaylistModel])
  case userSavedAlbums([SpotifyModel.PlaylistModel])
  
}

enum DetailItemType{
  case album(Album)
  case playlist(Playlist)
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
  var featuredPlaylists = [Playlist]()
  var userPlaylists = [Playlist]()
  var tracks = [Track]()
  var userRecentlyPlayed = [Album]()
  var userSavedAlbums = [Album]()
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
    var userPlaylists : PlaylistResponse?
    var userRecently : PlaylistTracksResponse?
    var userSavedAlbums : SavedAlbumsResponse?
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

    //User playlists.
    group.enter()
    apiManager.getUserPlaylist { result in
      switch result {

      case .success(let playlists):
        userPlaylists = playlists
      case .failure(let error):
        print(error.localizedDescription)
      }
      group.leave()
    }

    //User Recently Played
    group.enter()
    apiManager.getUserRecentlyPlayed { result in
      switch result {

      case .success(let recentlyPlayed):
        userRecently = recentlyPlayed
      case .failure(let error):
        print(error.localizedDescription)
      }
      group.leave()
    }

    //User Recently Saved Albums
    group.enter()
    apiManager.getUserSavedAlbums { result in
      switch result {

      case .success(let albums):
        userSavedAlbums = albums
      case .failure(let error):
        print(error)
      }
      group.leave()
    }


    group.notify(queue: .main) {
        guard let releases = newReleases?.albums.items,
              let featuredPlaylists = featuredPlaylists?.playlists.items,
              let tracks = recommendedTracks?.tracks,
              let userPlaylists = userPlaylists?.items,
              let userRecentlyPlayed = userRecently?.items,
              let userSavedAlbums = userSavedAlbums?.items
        else { return }


      self.configureViewModels(newAlbums: releases,playlists: featuredPlaylists,tracks: tracks,userPlaylists: userPlaylists,userRecently: userRecentlyPlayed, userSavedAlbums: userSavedAlbums)


    }
  }

  private func configureViewModels(newAlbums:[Album],playlists:[Playlist],tracks:[Track],userPlaylists:[Playlist],userRecently:[PlaylistItem],userSavedAlbums:[SavedAlbum]) {
    self.albums = newAlbums
    self.featuredPlaylists = playlists
    self.tracks = tracks
    self.userPlaylists = userPlaylists

    self.userRecentlyPlayed = userRecently.compactMap({ playlistItem in
      guard let album = playlistItem.track.album else {return .init(albumType: "", artists: [], availableMarkets: [], id: "", images: [], name: "", releaseDate: "", totalTracks: 0, externalUrls: .init(spotify: ""))}
      return .init(albumType: album.albumType, artists: album.artists, availableMarkets: album.availableMarkets, id: album.id, images: album.images, name: album.name, releaseDate: album.releaseDate, totalTracks: album.totalTracks, externalUrls: album.externalUrls)
    })

    self.userSavedAlbums = userSavedAlbums.compactMap({
      .init(albumType: $0.album.albumType, artists: $0.album.artists, availableMarkets: $0.album.availableMarkets, id: $0.album.id, images: $0.album.images, name: $0.album.name, releaseDate: $0.album.releaseDate, totalTracks: $0.album.totalTracks, externalUrls: $0.album.externalUrls)
    })
   
    sections.append(.newReleases(newAlbums.compactMap({
      .init(name: $0.name, image: $0.images.first?.url ?? "", numberOfTracks: $0.totalTracks, artistName: $0.artists.first?.name ?? "")
    })))

    sections.append(.featuredPlaylists(playlists.compactMap({
      .init(name: $0.name, image: $0.images.first?.url ?? "", creatorName: $0.owner.displayName, description: $0.itemDescription)
    })))

    sections.append(.userPlaylists(userPlaylists.compactMap({
      .init(name: $0.name, image: $0.images.first?.url ?? "", creatorName: $0.owner.displayName, description: $0.itemDescription)
    })))

    sections.append(.userRecently(userRecently.compactMap({ item in
      guard let album = item.track.album else {return nil}

      return SpotifyModel.PlaylistModel.init(name: album.name, image: album.images.first?.url ?? "", creatorName: album.artists.first?.name ?? "", description: album.name)
    })))

    sections.append(.userSavedAlbums(userSavedAlbums.compactMap({
      .init(name: $0.album.name, image: $0.album.images.first?.url ?? "", creatorName: $0.album.artists.first?.name ?? "", description: $0.album.name)
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
    case .userPlaylists(let playlists):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturedPlaylistCollectionViewCell
      cell.configure(model: playlists[indexPath.row])
      return cell

    case.userRecently(let playlists):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturedPlaylistCollectionViewCell
      cell.configure(model: playlists[indexPath.row])
      return cell

    case.userSavedAlbums(let playlists):
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
    case .userPlaylists(let playlists):
      return playlists.count
    case .userRecently(let playlists):
      return playlists.count
    case .userSavedAlbums(let albums):
      return albums.count
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
    case .userPlaylists:
      header.configure(with: "Your playlists")
    case .userRecently:
      header.configure(with: "Recently Played")
    case.userSavedAlbums:
      header.configure(with: "Recently Saved Albums")
    case .recommendedTracks:
      header.configure(with: "Recommended Tracks")
    }
    return header

  }

  func didSelectRowAt(indexPath: IndexPath) {

    let section = sections[indexPath.section]

    switch section {

    case .newReleases:
      view?.pushToAlbumDetailsVC(item: .album(albums[indexPath.row]))
    case .featuredPlaylists:
      view?.pushToAlbumDetailsVC(item: .playlist(featuredPlaylists[indexPath.row]))
      return
    case.userPlaylists:
      view?.pushToAlbumDetailsVC(item: .playlist(userPlaylists[indexPath.row]))
    case .userRecently:
      
      view?.pushToAlbumDetailsVC(item: .album(userRecentlyPlayed[indexPath.row]))

    case .userSavedAlbums:
      view?.pushToAlbumDetailsVC(item: .album(userSavedAlbums[indexPath.row]))

    case .recommendedTracks:
      return
    }
  }


}
