//
//  TabBarViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit
import SnapKit
import AVFoundation

protocol TabBarViewInterface:AnyObject{
  var player : AVPlayer?{get set}
  func style()
  func layout()
  func configureViewControllers()
  func configurePlayerView(url:String)
  func getTrack(track:Track)
  func getRecentTrack()

}

final class TabBarViewController: UITabBarController {
  let playerView = PlayerView()
  var player : AVPlayer?
  var track : Track?
  let vc1 = HomeViewController()
  let vc2 = SearchViewController()
  let vc3 = LibraryViewController()
  lazy var viewModel = TabBarViewModel(view: self)
  private var playerItem:AVPlayerItem?
    override func viewDidLoad() {
        super.viewDidLoad()

      viewModel.viewDidLoad()

    }

  @objc func didTapView(_ sender: UITapGestureRecognizer){
    guard let player = player,let track = track else {
      return
    }

    let vc = PlayerViewController(track: track, player: player)
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }


  @objc func didGetTrackID(_ track:Notification){
    UserDefaults.standard.didTapTrack = true
    guard let id = track.object as? String else { return}
    viewModel.fetchTrack(id: id)
  }
  @objc func didTapPlayButton(){
    if !playerView.isPlaying {
      player?.pause()
    }else {
      player?.play()
    }
  }

}


extension TabBarViewController:TabBarViewInterface{

  func style() {

    tabBar.backgroundColor = .black
    playerView.isUserInteractionEnabled = true
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
    playerView.addGestureRecognizer(gesture)


    NotificationCenter.default.addObserver(self, selector: #selector(didGetTrackID(_:)), name: .trackNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didTapPlayButton), name: .didTapPlayButton, object: nil)

  }

  func layout() {
    view.addSubview(playerView)
    playerView.snp.makeConstraints { make in
      make.left.equalToSuperview()
      make.bottom.equalTo(tabBar.snp.top)
      make.right.equalToSuperview()
      make.height.width.equalTo(50)
  }

  }

  func configureViewControllers() {

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

  func getRecentTrack() {
    viewModel.getRecentTrack()
  }
  
  func configurePlayerView(url:String) {


    guard let trackUrl = url.asURL else {return}

    self.playerItem = AVPlayerItem(url: trackUrl)
        self.player = AVPlayer(playerItem: self.playerItem)

    player?.play()

    self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { [weak self] (time) in

      if let duration  = self?.player?.currentItem?.duration {
        let playerCurrentTime = CMTimeGetSeconds((self?.player!.currentTime())!)

        if playerCurrentTime >  CMTimeGetSeconds(duration) - 1{
        self?.player?.seek(to: .zero)
      }
      }
    })

  }

  func getTrack(track: Track) {
    playerView.configure(track: track)
    self.track = track
  }



}
