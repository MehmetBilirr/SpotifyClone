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
  private let logOutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
      viewModel.viewDidLoad()
    }


}


extension ProfileViewController:ProfileViewInterface {

  func style() {
    imageView.configureImageView(contentModee: .scaleAspectFit)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.imageView.sd_setImage(with: self.viewModel.imageUrl().asURL)
    }

    logOutButton.configureStyleTitleButton(title:"Log Out", titleColor: .black, backgroundClr: .white.withAlphaComponent(0.9),cornerRds: logOutButton.frame.height / 2)
    logOutButton.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)


    
  }

  @objc func didTapLogOut(){

    AuthManager.shared.signOut { [weak self] success in
        if success {
            DispatchQueue.main.async {
                let navC = UINavigationController(rootViewController: WelcomeViewController())
                navC.navigationBar.prefersLargeTitles = true
                navC.modalPresentationStyle = .fullScreen
                self?.present(navC, animated: true, completion: {
                    self?.navigationController?.popToRootViewController(animated: true)
                })

            }
        }}
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
      make.bottom.equalTo(-200)
    }

    view.addSubview(logOutButton)

    logOutButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(tableView.snp.bottom).offset(20)
      make.height.equalTo(50)
      make.width.equalTo(100)

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
