//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit
import SnapKit

protocol WelcomeViewInterface:AnyObject{
  func style()
  func layout()
}


class WelcomeViewController: UIViewController {
  private let signInButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
  private lazy var viewModel = WelcomeViewModel(view: self)
  private let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

      viewModel.viewDidLoad()
    }

}

extension WelcomeViewController:WelcomeViewInterface {

  func style (){
    title = "Welcome to Spotify"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always

    signInButton.configureStyle(title: "Sign In", titleColor: .black, backgroundClr: .white.withAlphaComponent(0.9),cornerRds: signInButton.frame.height / 2)
    imageView.configureCustomImageView(imageName: "logo")

  }


  func layout(){

    view.addSubview(signInButton)
    signInButton.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(50)
      make.right.equalToSuperview().offset(-50)
      make.bottom.equalToSuperview().offset(-50)
      make.height.equalTo(50)
    }

    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(50)
      make.right.equalToSuperview().offset(-50)
      make.width.equalTo(view.width / 2)
      make.height.equalTo(view.height / 2)
      make.center.equalToSuperview()

    }

  }

}
