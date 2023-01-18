//
//  SettingsViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import UIKit

protocol SettingsViewInterface:AnyObject {

  func configureTableView()
  func configureSections()
  func didTapProfile()

}

class SettingsViewController: UIViewController {
    private let tableView = UITableView()
    private lazy var viewModel = SettingsViewModel(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      viewModel.viewDidLoad()

    }

  override func viewDidLayoutSubviews() {
    tableView.frame = view.bounds
  }

}

extension SettingsViewController:SettingsViewInterface {
  func configureTableView(){
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }

  func configureSections(){
    viewModel.configureSections()
  }

  func didTapProfile(){
    let vc = ProfileViewController()
    vc.title = "Profile"
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)

  }


}


extension SettingsViewController:UITableViewDelegate,UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowsInSection(section: section)
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.titleForHeaderInSection(section: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = viewModel.cellText(indexPath: indexPath)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelectRowAt(indexpath: indexPath)

  }



}
