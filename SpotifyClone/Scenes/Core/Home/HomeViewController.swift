//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage( systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings) )

      APIManager.shared.getRecommendedGenres() { result in
        switch result {

        case .success(let newReleases):
          print(newReleases)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }


  @objc func didTapSettings() {
    let vc = SettingsViewController()
    vc.title = "Settings"
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }
}
