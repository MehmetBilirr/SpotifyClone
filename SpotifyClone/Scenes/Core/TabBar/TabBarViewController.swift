//
//  TabBarViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
      configure()

    }

  private func configure(){

    let vc1 = HomeViewController()
    let vc2 = SearchViewController()
    let vc3 = LibraryViewController()

    vc1.title = "Spotify"
    vc2.title = "Search"
    vc3.title = "Library"

    let nav1  = UINavigationController(rootViewController: vc1)
    let nav2  = UINavigationController(rootViewController: vc2)
    let nav3  = UINavigationController(rootViewController: vc3)

    let navs = [nav1, nav2, nav3]

    navs.forEach { nav in
        nav.navigationBar.tintColor = .label
        nav.navigationBar.prefersLargeTitles = true
    }

    nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
    nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
    nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "square.stack.3d.down.forward"), tag: 3)

    setViewControllers([nav1, nav2, nav3], animated: true)
  }
    



}