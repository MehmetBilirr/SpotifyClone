//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import UIKit

protocol ProfileViewInterface:AnyObject {
  func configureTableView()
  func getUser()

}

class ProfileViewController: UIViewController {
  private let tableView = UITableView()
  private lazy var viewModel = ProfileViewModel(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()
      viewModel.viewDidLoad()
    }

  override func viewDidLayoutSubviews() {
    tableView.frame = view.bounds
  }


}


extension ProfileViewController:ProfileViewInterface {


  func configureTableView() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }

  func getUser() {
    viewModel.getUser()
  }
}


extension ProfileViewController:UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "asda"
    return cell
  }



}
