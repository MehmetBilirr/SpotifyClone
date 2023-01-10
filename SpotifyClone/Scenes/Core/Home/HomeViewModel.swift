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
  case recommendedTracks
}

protocol HomeViewModelInterface:AnyObject {
  var view:HomeViewInterface?{get set}
  func viewDidLoad()
  func fetchData()
  func numberOfSections()->Int
  func cellForItemAt(collectionView:UICollectionView,indexPath:IndexPath)->UICollectionViewCell
  func numberOfItemsInSection(section:Int)->Int
  func configureHeaderView(kind:String,collectionView:UICollectionView,indexPath:IndexPath)->UICollectionReusableView

}

class HomeViewModel {
  weak var view: HomeViewInterface?
  private let apiManager : APIManager
  var sections = [BrowseSectionType]()
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
      print("tracks*\(tracks)")
      self.configureViewModels(newAlbums: releases,playlists: playlists)
//        self.configureViewModels(newAlbums: releases,
//                                 playlists: playlists,
//                                 tracks: tracks)

    }
  }

  private func configureViewModels(newAlbums:[Album],playlists:[Playlist]) {
    sections.append(.newReleases(newAlbums.compactMap({
      .init(name: $0.name, image: $0.images.first?.url ?? "", numberOfTracks: $0.totalTracks, artistName: $0.artists.first?.name ?? "")
    })))

    sections.append(.featuredPlaylists(playlists.compactMap({
      .init(name: $0.name, image: $0.images.first?.url ?? "", creatorName: $0.owner.displayName)
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
    case .recommendedTracks:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath)
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
    case .recommendedTracks:
      return 1
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


}