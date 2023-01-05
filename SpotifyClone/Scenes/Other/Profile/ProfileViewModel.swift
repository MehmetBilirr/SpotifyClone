//
//  ProfileViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import Foundation

protocol ProfileViewModelInterface:AnyObject {
  var view:ProfileViewInterface?{get set}
  func viewDidLoad()
  func getUser()


}


class ProfileViewModel:ProfileViewModelInterface {
  weak var view: ProfileViewInterface?
  private let apiManager : APIManager

  init(view:ProfileViewInterface,ApiManager:APIManager = APIManager.shared){
    self.view = view
    self.apiManager = ApiManager
  }
  func viewDidLoad() {
    view?.configureTableView()
  }
  func getUser() {
    apiManager.getCurrentUserProfile { result in
      switch result {
      case .success(let user):
        print(user)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }


}
