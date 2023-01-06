//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import UIKit
import SnapKit
import SDWebImage

protocol ProfileViewInterface:AnyObject {
  func configureTableView()
  func getUser()
  func reloadData()
  func style()
  func layout()
  func failedToGetProfile()

}

class ProfileViewController: UIViewController {
  private let tableView = UITableView()
  private lazy var viewModel = ProfileViewModel(view: self)
  private let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
      viewModel.viewDidLoad()
    }


}


extension ProfileViewController:ProfileViewInterface {

  func style() {
    imageView.configureImageView()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.imageView.sd_setImage(with: self.viewModel.imageUrl().asURL)
    }


    
  }

  func layout() {

    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(150)
      make.width.height.equalTo(200)
    }

    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(100)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

  func configureTableView() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }

  func getUser() {
    viewModel.getUser()
  }

  func reloadData() {
      self.tableView.reloadData()

  }
   func failedToGetProfile() {
      let label = UILabel(frame: .zero)
      label.text = "Failed to load profile"
      label.sizeToFit()
      label.textColor = .secondaryLabel
      view.addSubview(label)
      label.center = view.center
  }
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = viewModel.cellForRowAt(indexPath: indexPath)
    return cell
  }



}
