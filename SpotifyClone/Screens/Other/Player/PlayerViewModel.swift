//
//  PlayerViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 27.01.2023.
//

import Foundation

protocol PlayerViewModelInterface {
  var view:PlayerViewInterface?{get set}
  func viewDidLoad()
}

final class PlayerViewModel {
  weak var view: PlayerViewInterface?
  init(view:PlayerViewInterface){
    self.view = view
  }

}


extension PlayerViewModel:PlayerViewModelInterface {
  func viewDidLoad() {
    view?.style()
    view?.layout()
    view?.configureBarButtons()
    view?.configurePlayer()
  }


}
