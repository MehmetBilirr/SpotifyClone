//
//  TabBarViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 21.01.2023.
//

import Foundation



protocol TabBarViewModelInterface:AnyObject {
  var view:TabBarViewInterface?{get set}
  func viewDidLoad()
  func fetchTrack(id:String)
  func getRecentTrack()
  
}

final class TabBarViewModel {
weak var view: TabBarViewInterface?
  let apiManager:APIManager?
  init(view:TabBarViewInterface,apiManager:APIManager=APIManager.shared){
    self.view = view
    self.apiManager  = apiManager
  }


}

extension TabBarViewModel:TabBarViewModelInterface {

  func viewDidLoad() {
    view?.configureViewControllers()
    view?.style()
    view?.layout()
    view?.getRecentTrack()

  }

  func fetchTrack(id: String) {
    apiManager?.getTrack(id: id) { result in
      switch result {

      case .success(let track):
        self.view?.configurePlayerView(url: track.previewURL ?? "")
        self.view?.getTrack(track: track)
      case .failure(let error):
        print(error)
      }
    }
  }
  func getRecentTrack() {

    apiManager?.getUserRecentlyPlayed(completion: { result in
      switch result {

      case .success(let tracks):
        guard let track = tracks.items.first?.track else {return}
        self.view?.getTrack(track: track)
        self.view?.configurePlayerView(url: track.previewURL ?? "")
        self.view?.player?.pause()
      case .failure(let error):
        print(error.localizedDescription)
      }
    })
  }
}
