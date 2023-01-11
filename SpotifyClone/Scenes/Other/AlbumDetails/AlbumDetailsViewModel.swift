//
//  AlbumDetailsViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import Foundation
import UIKit

protocol AlbumDetailsViewModelInterface {
  var view:AlbumDetailsViewInterface?{get set}
  func viewDidLoad()
  func fetchData(item:DetailItemType)
  func cellForItemAt(collectionView:UICollectionView,indexPath:IndexPath)->UICollectionViewCell
  func numberOfItemsInSection()->Int
  func configureHeader(indexPath:IndexPath,item:DetailItemType,collectionView:UICollectionView,kind:String)->UICollectionReusableView

}

class AlbumDetailsViewModel {
  weak var view: AlbumDetailsViewInterface?
  var tracks = [SpotifyModel.TrackModel]()
  var apiManager:APIManager

  init(view:AlbumDetailsViewInterface,apiManager:APIManager = APIManager.shared){
    self.view = view
    self.apiManager = apiManager
  }

}


extension AlbumDetailsViewModel:AlbumDetailsViewModelInterface {

  func viewDidLoad() {
    view?.configureCollectionView()
    view?.fetchData()
  }

  func fetchData(item: DetailItemType) {

    switch item {
    case .album(let album):
      apiManager.getAlbumDetails(albumID: album.id) { result in
        switch result {

        case .success(let album):
          self.configureTracks(album: album)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    case .playlist(let playlist):
      apiManager.getPlaylistDetails(playlistId: playlist.id) { result in
        switch result {

        case .success(let playlist):
          self.tracks = playlist.tracks.items.compactMap({
            .init(name: $0.track.name, artistName: $0.track.artists.first?.name ?? "", image: nil)
          })
          self.view?.reloadData()
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }

  }

  private func configureTracks(album:AlbumDetailsResponse){
    tracks = album.tracks.items.compactMap({
      .init(name: $0.name, artistName: $0.artists.first?.name ?? "", image: nil)
    })
    view?.reloadData()

  }

  func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumDetailsCollectionViewCell.identifier, for: indexPath) as! AlbumDetailsCollectionViewCell
    cell.configure(track: tracks[indexPath.row])
    return cell
  }

  func numberOfItemsInSection() -> Int {
    return tracks.count
  }

  func configureHeader(indexPath: IndexPath, item: DetailItemType, collectionView: UICollectionView, kind: String) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier,
        for: indexPath) as? AlbumHeaderCollectionReusableView,
          kind == UICollectionView.elementKindSectionHeader else {
        return UICollectionReusableView()
    }
    header.configure(item: item)
    return header
  }



}

