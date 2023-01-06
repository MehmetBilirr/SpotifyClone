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
  func configureRows(profile:UserProfile)
  func numberOfRows()->Int
  func cellForRowAt(indexPath:IndexPath)->String
  func imageUrl()->String


}


class ProfileViewModel:ProfileViewModelInterface {
  weak var view: ProfileViewInterface?
  var profile:UserProfile?
  var rows = [String]()
  private let apiManager : APIManager

  init(view:ProfileViewInterface,ApiManager:APIManager = APIManager.shared){
    self.view = view
    self.apiManager = ApiManager
  }
  func viewDidLoad() {
    view?.getUser()
    view?.configureTableView()

    view?.style()
    view?.layout()


  }
  func getUser() {
    apiManager.getCurrentUserProfile { result in
      switch result {
      case .success(let user):
        self.profile = user
        self.configureRows(profile: user)
        self.view?.reloadData()
      case .failure(let error):
        self.view?.failedToGetProfile()
        print(error.localizedDescription)
      }
    }
  }


  func configureRows(profile:UserProfile) {
    rows.append("Full Name:  \(profile.displayName)")
    rows.append("Email:  \(profile.email)")
    rows.append("User ID:  \(profile.id)")
    rows.append("Plan:  \(profile.product)")
  }

  func imageUrl() -> String {
    return profile?.images.first?.url ?? ""
  }



  func numberOfRows() -> Int {
    rows.count
  }

  func cellForRowAt(indexPath: IndexPath) -> String {
    rows[indexPath.row]
  }


}
