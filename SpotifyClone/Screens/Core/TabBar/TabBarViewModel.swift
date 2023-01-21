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
  
}

class TabBarViewModel {
weak var view: TabBarViewInterface?
  init(view:TabBarViewInterface){
    self.view = view
  }


}

extension TabBarViewModel:TabBarViewModelInterface {

  func viewDidLoad() {
    view?.configureViewControllers()
    view?.style()
    view?.layout()

  }

  func fetchTrack(id: String) {
    APIManager.shared.getTrack(id: id) { result in
      switch result {

      case .success(let track):
        self.view?.configurePlayerView(url: track.previewURL ?? "")
        self.view?.getTrack(track: track)
      case .failure(let error):
        print(error)
      }
    }
  }
}
