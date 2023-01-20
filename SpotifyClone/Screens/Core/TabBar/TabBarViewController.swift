//
//  TabBarViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit
import SnapKit

final class TabBarViewController: UITabBarController {
  let uview = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
      configure()

      uview.isHidden = true
      tabBar.backgroundColor = .black
      view.addSubview(uview)
      uview.backgroundColor = .white
      uview.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.bottom.equalTo(tabBar.snp.top)
        make.right.equalToSuperview()
        make.height.width.equalTo(50)
      }

    }

  private func configure(){

    let vc1 = HomeViewController()
    let vc2 = SearchViewController()
    let vc3 = LibraryViewController()

    vc1.title = "Spotify"
    vc2.title = "Search"
    vc3.title = "Your Library"

    let nav1  = UINavigationController(rootViewController: vc1)
    let nav2  = UINavigationController(rootViewController: vc2)
    let nav3  = UINavigationController(rootViewController: vc3)

    let navs = [nav1, nav2, nav3]

    navs.forEach { nav in
        nav.navigationBar.tintColor = .label
        nav.navigationBar.prefersLargeTitles = true
    }

    tabBar.tintColor  = .white
    nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"),selectedImage: UIImage(systemName: "house.fill"))
    nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"),selectedImage: UIImage(systemName: "magnifyingglass.fill"))
    nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "square.stack.3d.down.forward"),selectedImage: UIImage(systemName: "square.stack.3d.down.forward.fill"))

    setViewControllers([nav1, nav2, nav3], animated: true)
  }
    



}
