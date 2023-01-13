//
//  AlbumDetailsViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import Foundation
import UIKit

protocol ContentDetailsViewModelInterface {
  var view:ContentDetailsViewInterface?{get set}
  func viewDidLoad()
  func fetchData(item:ContentType)
  func cellForItemAt(collectionView:UICollectionView,indexPath:IndexPath)->UICollectionViewCell
  func numberOfItemsInSection()->Int
  func configureHeader(indexPath:IndexPath,item:ContentType,collectionView:UICollectionView,kind:String)->UICollectionReusableView

}

class ContentDetailsViewModel {
  weak var view: ContentDetailsViewInterface?
  var tracks = [SpotifyModel.TrackModel]()
  var apiManager:APIManager

  init(view:ContentDetailsViewInterface,apiManager:APIManager = APIManager.shared){
    self.view = view
    self.apiManager = apiManager
  }

}


extension ContentDetailsViewModel:ContentDetailsViewModelInterface {

  func viewDidLoad() {
    view?.configureCollectionView()
    view?.fetchData()
    view?.configureShareButton()
  }

  func fetchData(item: ContentType) {

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
    default:
      break
    }

  }

  private func configureTracks(album:AlbumDetailsResponse){
    tracks = album.tracks.items.compactMap({
      .init(name: $0.name, artistName: $0.artists.first?.name ?? "", image: nil)
    })
    view?.reloadData()

  }

  func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentetailsCollectionViewCell.identifier, for: indexPath) as! ContentetailsCollectionViewCell
    cell.configure(track: tracks[indexPath.row])
    return cell
  }

  func numberOfItemsInSection() -> Int {
    return tracks.count
  }

  func configureHeader(indexPath: IndexPath, item: ContentType, collectionView: UICollectionView, kind: String) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: ContentHeaderCollectionReusableView.identifier,
        for: indexPath) as? ContentHeaderCollectionReusableView,
          kind == UICollectionView.elementKindSectionHeader else {
        return UICollectionReusableView()
    }
    header.configure(item: item)
    return header
  }



}

