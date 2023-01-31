//
//  WelcomeViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation

protocol WelcomeViewModelInterface:AnyObject {
  var view:WelcomeViewInterface? { get set}
  func viewDidLoad()
  

}

final class WelcomeViewModel:WelcomeViewModelInterface {
  weak var view:(WelcomeViewInterface)?

  init(view:WelcomeViewController) {
    self.view = view
  }


  func viewDidLoad() {
    view?.style()
    view?.layout()
  }



}
