//
//  LibraryViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 20.01.2023.
//

import Foundation

protocol LibraryViewModelInterface:AnyObject {
  var view:LibraryViewInterface?{get set}
  func viewDidLoad()
  func fetchData()
}


class LibraryViewModel {

  weak var view: LibraryViewInterface?
  private let apiManager:APIManager

  init(view:LibraryViewInterface,apiManager:APIManager=APIManager.shared){
    self.view = view
    self.apiManager = apiManager
  }
}

extension LibraryViewModel:LibraryViewModelInterface{
  func viewDidLoad() {


    view?.configureSectionButtons()
    view?.configureTableView()

  }

  func fetchData() {
    
  }
}
