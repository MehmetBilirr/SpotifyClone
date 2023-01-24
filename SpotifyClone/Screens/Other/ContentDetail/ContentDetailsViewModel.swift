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
  func fetchData(content:ContentType)
  func cellForItemAt(collectionView:UICollectionView,indexPath:IndexPath)->UICollectionViewCell
  func numberOfItemsInSection()->Int
  func configureHeader(indexPath:IndexPath,content:ContentType,collectionView:UICollectionView,kind:String)->UICollectionReusableView
  func didSelectItemAt(_ indexPath:IndexPath)

}

class ContentDetailsViewModel {
  weak var view: ContentDetailsViewInterface?
  var tracks = [Track]()
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
  


  func fetchData(content: ContentType) {
    tracks = []
    switch content {
    case .album(let album):
      apiManager.getAlbumDetails(albumID: album.id) { result in

        switch result {
        case .success(let album):
          let tracks = album.tracks.items
          self.configureTracks(tracks: tracks)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    case .playlist(let playlist):
      apiManager.getPlaylistDetails(playlistId: playlist.id) { result in
        switch result {

        case .success(let playlist):
          let tracks = playlist.tracks.items.compactMap({$0.track})
  
          self.configureTracks(tracks: tracks)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    default:
      break
    }

  }

  private func configureTracks(tracks:[Track]){
    self.tracks = tracks
    view?.reloadData()

  }

  func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    if tracks[indexPath.row].album == nil {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentetailsCollectionViewCell.identifier, for: indexPath) as! ContentetailsCollectionViewCell
      cell.configure(track: tracks[indexPath.row])
      return cell
    }else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath) as! TracksCollectionViewCell
      cell.configure(track: tracks[indexPath.row])
      return cell
    }

  }

  func numberOfItemsInSection() -> Int {
    return tracks.count
  }

  func configureHeader(indexPath: IndexPath, content: ContentType, collectionView: UICollectionView, kind: String) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: ContentHeaderCollectionReusableView.identifier,
        for: indexPath) as? ContentHeaderCollectionReusableView,
          kind == UICollectionView.elementKindSectionHeader else {
        return UICollectionReusableView()
    }
    header.configure(content: content)
    return header
  }


  func didSelectItemAt(_ indexPath: IndexPath) {
    

    view?.pushToPlayer(track: tracks[indexPath.row])
  }

}

