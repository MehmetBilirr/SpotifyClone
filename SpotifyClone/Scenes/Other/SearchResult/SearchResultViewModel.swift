//
//  SearchResultViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 13.01.2023.
//

import Foundation
import UIKit

protocol SearchResultViewModelInterface:AnyObject{
  var view:SearchResultViewInterface?{get set}
  func viewDidLoad()
  func getResults(result:[ContentType])
  func prepareSections(searchResults: [ContentType])
  func numberOfSections()->Int
  func titleForHeaderInSection(_ section:Int)->String
  func cellForRowAt(_ indexPath:IndexPath,_ tableView:UITableView)->UITableViewCell
 func numberOfRowsInSection(_ section:Int)->Int
}


class SearchResultViewModel {
  var sections = [SearchSection]()
  weak var view: SearchResultViewInterface?
  var searchResults = [ContentType]()

  var tracks = [ContentType]()
  var albums = [ContentType]()
  var artists = [ContentType]()
  var playlists = [ContentType]()

  init(view:SearchResultViewInterface){
    self.view = view
  }

}


extension SearchResultViewModel:SearchResultViewModelInterface {
  func viewDidLoad() {
    view?.configureTableView()

  }

  func getResults(result: [ContentType]) {
    prepareSections(searchResults: result)

  }
  func prepareSections(searchResults: [ContentType]) {
    albums.removeAll(keepingCapacity: true)
    tracks.removeAll(keepingCapacity: true)
    playlists.removeAll(keepingCapacity: true)
    artists.removeAll(keepingCapacity: true)
    searchResults.compactMap({
      switch $0 {

      case .album(let album):

        albums.append(.album(album))
      case .playlist(let playlist):
        playlists.append(.playlist(playlist))
      case .track(let track):
        tracks.append(.track(track))
      case .artist(let artist):
        artists.append(.artist(artist))
      }
    })

    self.sections = [
        SearchSection(title: "Songs", results: tracks),
        SearchSection(title: "Albums", results: albums),
        SearchSection(title: "Artists", results: artists),
        SearchSection(title: "Playlists", results: playlists)
    ]

    view?.reloadData()

  }

  func numberOfSections() -> Int {
    return sections.count
  }

  func titleForHeaderInSection(_ section: Int) -> String {
    return sections[section].title
  }

  func numberOfRowsInSection(_ indexPath: IndexPath) -> Int {
    return sections[indexPath.section].results.count

    }

  func cellForRowAt(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
    let section = sections[indexPath.section]
    cell.configure(content: section.results[indexPath.row])

    return cell
  }

  func numberOfRowsInSection(_ section: Int) -> Int {
    let section = sections[section]
    return section.results.count
  }
}
