//
//  SettingsViewModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import Foundation


protocol SettingsViewModelInterface:AnyObject{
  var view:SettingsViewInterface?{get set}
  func viewDidLoad()
  func configureSections()
  func numberOfSections()->Int
  func numberOfRowsInSection(section:Int)->Int
  func titleForHeaderInSection(section:Int)->String
  func cellText(indexPath:IndexPath)->String
  func didSelectRowAt(indexpath:IndexPath)

}

final class SettingsViewModel {
  var sections = [Section]()
  weak var view: SettingsViewInterface?

  init(view:SettingsViewInterface){
    self.view = view
  }


}

extension SettingsViewModel:SettingsViewModelInterface {
  func viewDidLoad() {
    view?.configureTableView()
    view?.configureSections()
  }

  func configureSections() {
    sections = [.init(sectionName: "Profile", rowsInSection: [.init(title: "View Your Profile", handler: { [weak self] in

      self?.view?.didTapProfile()

    })]),
                .init(sectionName: "Account", rowsInSection: [.init(title: "Log Out", handler: {
                  [weak self] in
                  print("asdasd")

                })])]
  }

  func numberOfSections() -> Int {
    sections.count
  }

  func numberOfRowsInSection(section: Int) -> Int {
    sections[section].rowsInSection.count
  }

  func titleForHeaderInSection(section: Int) -> String {
    return sections[section].sectionName
  }

  func cellText(indexPath: IndexPath) -> String {
    sections[indexPath.section].rowsInSection[indexPath.row].title
  }

  func didSelectRowAt(indexpath: IndexPath) {
    sections[indexpath.section].rowsInSection[indexpath.row].handler()

  }


}
