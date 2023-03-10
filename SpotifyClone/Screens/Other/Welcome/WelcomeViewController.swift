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


final class WelcomeViewController: UIViewController {
  private let signInButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
  private lazy var viewModel = WelcomeViewModel(view: self)
  private let imageView = UIImageView()
  private let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

      viewModel.viewDidLoad()


    }
  override func viewWillDisappear(_ animated: Bool) {
    view.isHidden = true
  }
  override func viewWillAppear(_ animated: Bool) {
    view.isHidden = false
  }

}

extension WelcomeViewController:WelcomeViewInterface {

  func style (){

    label.configureStyle(size: 40, weight: .bold, color: .white)
    label.text = "Millions of songs\n free on Spotify."

    signInButton.configureStyleTitleButton(title: "Sign In", titleColor: .black, backgroundClr: .white.withAlphaComponent(0.9),cornerRds: signInButton.frame.height / 2)

    signInButton.addTarget(self, action: #selector(didTapSignInButton(_:)), for: .touchUpInside)

    imageView.configureImageView(imageName: "logo", contentModee: .scaleAspectFit)

  }

  @objc func didTapSignInButton(_ sender:UIButton) {
    
    let vc = AuthViewController()

    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
    vc.completionHandler = { [weak self] success in
        DispatchQueue.main.async {
            self?.handleSignIn(success: success)
        }
    }
  }

  private func handleSignIn(success: Bool) {
      guard success else {
          let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
          present(alert, animated: true)
          return

      }
      let mainAppTabBarVC = TabBarViewController()
      mainAppTabBarVC.modalPresentationStyle = .fullScreen
    mainAppTabBarVC.modalTransitionStyle = .flipHorizontal
      present(mainAppTabBarVC, animated: true)
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
    view.addSubview(label)
    label.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(imageView.snp.top).offset(-30)
    }

  }

}
