//
//  HomeViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//


import Foundation
import UIKit

enum BrowseSectionType {
  case newReleases([Album])
  case featuredPlaylists([Playlist])
  case userPlaylists([Playlist])
  case recommendedTracks([SpotifyModel.TrackModel])
  case userRecently(Set<Album>)
  case userSavedAlbums([Playlist])
  
}

enum ContentType{
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
  var userRecentlyPlayed :Set<Album> = []
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
    var featuredPlaylists: CategoryPlaylistsResponse?
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
              let featuredPlaylists = featuredPlaylists?.playlists.items,
              let tracks = recommendedTracks?.tracks,
              let userPlaylists = userPlaylists?.items,
              let userRecentlyPlayed = userRecently?.items,
              let userSavedAlbums = userSavedAlbums?.items
        else { return }


      self.configureViewModels(newAlbums: releases,featuredPlaylists: featuredPlaylists,tracks: tracks,userPlaylists: userPlaylists,userRecently: userRecentlyPlayed, userSavedAlbums: userSavedAlbums)


    }
  }

  private func configureViewModels(newAlbums:[Album],featuredPlaylists:[Playlist],tracks:[Track],userPlaylists:[Playlist],userRecently:[PlaylistItem],userSavedAlbums:[SavedAlbum]) {
    self.albums = newAlbums
    self.featuredPlaylists = featuredPlaylists
    self.tracks = tracks
    self.userPlaylists = userPlaylists

    for items in userRecently {
      guard let album = items.track.album else {return}
      self.userRecentlyPlayed.insert(album)
    }
    
    self.userSavedAlbums = userSavedAlbums.compactMap({
      .init(albumType: $0.album.albumType, id: $0.album.id, images: $0.album.images, externalUrls: $0.album.externalUrls, name: $0.album.name, releaseDate: $0.album.releaseDate, totalTracks: $0.album.totalTracks, artists: $0.album.artists, availableMarkets: $0.album.availableMarkets)
    })

    sections.append(.userRecently(userRecentlyPlayed))

    sections.append(.featuredPlaylists(featuredPlaylists))

    sections.append(.userPlaylists(userPlaylists))

    sections.append(.userSavedAlbums(userSavedAlbums.compactMap({
      .init(itemDescription: $0.album.name, externalUrls: $0.album.externalUrls, id: $0.album.id, images: $0.album.images, name: $0.album.name, owner: .init(displayName: "", externalUrls: .init(spotify: ""), href: "", id: "", type: "", uri: ""))
    })))

    sections.append(.newReleases(newAlbums))

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
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
      cell.configure(playlist: playlists[indexPath.row])
      return cell
    case .userPlaylists(let playlists):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
      cell.configure(playlist: playlists[indexPath.row])
      return cell

    case.userRecently(let playlists):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyPlayedCollectionViewCell.identifier, for: indexPath) as! RecentlyPlayedCollectionViewCell
      let array = Array(playlists)
      cell.configure(album: array[indexPath.row])
      return cell

    case.userSavedAlbums(let playlists):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
      cell.configure(playlist: playlists[indexPath.row])
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
      let array = Array(userRecentlyPlayed)
      view?.pushToAlbumDetailsVC(item: .album(array[indexPath.row]))

    case .userSavedAlbums:
      view?.pushToAlbumDetailsVC(item: .album(userSavedAlbums[indexPath.row]))

    case .recommendedTracks:
      return
    }
  }


}
