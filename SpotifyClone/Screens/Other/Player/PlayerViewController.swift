//
//  PlayerViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 18.01.2023.
//

import UIKit
import SnapKit
import AVFoundation



protocol PlayerViewInterface {

  func style()
  func layout()
  func configurePlayer()


}

class PlayerViewController: UIViewController {
  private let shuffleButton = UIButton()
  private let backwardButton = UIButton()
  private let playButton = UIButton()
  private let forwardButton = UIButton()
  private let repeatButton = UIButton()
  private let trackNameLbl = UILabel()
  private let artistLbl = UILabel()
  private let currentTimeLbl = UILabel()
  private let totalTimeLbl = UILabel()
  private let slider: UISlider = {
      let slider = UISlider()
      slider.value = 0
      slider.tintColor = .white
      slider.maximumValue = 30
    slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
      return slider
  }()
  private let dismissButton = UIButton()
  private let dotButton = UIButton()
  private let imageView = UIImageView()
  private var player : AVPlayer?
  var playerItem:AVPlayerItem?
  var track:Track?
  var url:String?
  private var isPlaying = true
    override func viewDidLoad() {
        super.viewDidLoad()

      style()
      layout()
      configurePlayer()
    

    }

  init(track:Track,url:String?=nil){
    self.track = track
    self.url = url
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension PlayerViewController:PlayerViewInterface {



  func configurePlayer() {

    guard let previewUrl = track?.previewURL else {return}
    self.playerItem = AVPlayerItem(url: previewUrl.asURL!)
        self.player = AVPlayer(playerItem: self.playerItem)
    player?.play()

    self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (time) in
            if self.player!.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())

                let secs = Int(currentTime)
              self.slider.value = Float(secs)
                self.currentTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"

        }
    })
  }


  @objc func didTapCloseButton(){
    print("adad")
    dismiss(animated: true)
  }
  
  func style() {
    dismissButton.configureStyleSymbolButton(systemName: "chevron.down", pointSize: 20)
    dismissButton.tintColor = .white
    dismissButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)

    dotButton.configureStyleSymbolButton(systemName: "ellipsis", pointSize: 20)
    dotButton.tintColor = .gray

    imageView.configureImageView(contentModee: .scaleAspectFit)
    imageView.sd_setImage(with: track?.album?.images.first?.url.asURL ?? url?.asURL)

    trackNameLbl.configureStyle(size: 20, weight: .bold, color: .white)
    trackNameLbl.text = track?.name

    artistLbl.configureStyle(size: 15, weight: .thin, color: .white)
    artistLbl.text = track?.artists.first?.name


    currentTimeLbl.configureStyle(size: 14, weight: .thin, color: .gray)

    totalTimeLbl.configureStyle(size: 14, weight: .thin, color: .gray)
    totalTimeLbl.text = "0.30"

    shuffleButton.configureStyleSymbolButton(systemName: "shuffle", tintClr: .white,pointSize: 30)


    backwardButton.configureStyleSymbolButton(systemName: "backward.end.fill", tintClr: .white, pointSize: 40)
    backwardButton.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)

    playButton.configureStyleSymbolButton(systemName: "pause.circle.fill", tintClr: .white, pointSize: 80)
    playButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)


    forwardButton.configureStyleSymbolButton(systemName: "forward.end.fill", tintClr: .white, pointSize: 40)
    forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)

    repeatButton.configureStyleSymbolButton(systemName: "arrow.rectanglepath", tintClr: .white, pointSize: 30)

  }

  func stringFromTimeInterval(interval: TimeInterval) -> String {

         let interval = Int(interval)
         let seconds = interval % 60
         let minutes = (interval / 60) % 60
         let hours = (interval / 3600)
         return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
     }

  func layout() {

    view.addSubview(dismissButton)
    dismissButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(50)
      make.left.equalToSuperview().offset(10)
    }

    view.addSubview(dotButton)
    dotButton.snp.makeConstraints { make in
      make.right.equalToSuperview()
      make.top.equalTo(dismissButton.snp.top)
    }

    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(30)
      make.right.equalToSuperview().offset(-30)
      make.top.equalTo(dismissButton.snp.bottom).offset(50)
      make.height.equalTo(view.height / 2.3)
    }

    view.addSubview(trackNameLbl)
    trackNameLbl.snp.makeConstraints { make in
      make.left.equalTo(imageView.snp.left).offset(-10)
      make.top.equalTo(imageView.snp.bottom).offset(20)
    }

    view.addSubview(artistLbl)
    artistLbl.snp.makeConstraints { make in
      make.left.equalTo(trackNameLbl.snp.left)
      make.top.equalTo(trackNameLbl.snp.bottom).offset(2)
    }
    view.addSubview(slider)
    slider.snp.makeConstraints { make in
      make.left.equalTo(trackNameLbl.snp.left)
      make.right.equalTo(imageView.snp.right).offset(10)
      make.top.equalTo(artistLbl.snp.bottom).offset(20)

    }

    view.addSubview(currentTimeLbl)
    currentTimeLbl.snp.makeConstraints { make in
      make.left.equalTo(trackNameLbl.snp.left)
      make.top.equalTo(slider.snp.bottom).offset(2)
    }

    view.addSubview(totalTimeLbl)
    totalTimeLbl.snp.makeConstraints { make in
      make.right.equalTo(slider.snp.right)
      make.top.equalTo(slider.snp.bottom).offset(2)
    }

    view.addSubview(playButton)

      playButton.snp.makeConstraints { make in
        make.top.equalTo(totalTimeLbl.snp.bottom).offset(30)
        make.centerX.equalToSuperview()
      }

    view.addSubview(shuffleButton)
    shuffleButton.snp.makeConstraints { make in
      make.centerY.equalTo(playButton.snp.centerY)
      make.left.equalTo(trackNameLbl.snp.left)

    }

    view.addSubview(backwardButton)
      backwardButton.snp.makeConstraints { make in
        make.centerY.equalTo(playButton.snp.centerY)
        make.right.equalTo(playButton.snp.left).offset(-20)
      }


      view.addSubview(forwardButton)
        forwardButton.snp.makeConstraints { make in
          make.centerY.equalTo(playButton.snp.centerY)
          make.left.equalTo(playButton.snp.right).offset(20)
        }


    view.addSubview(repeatButton)
      repeatButton.snp.makeConstraints { make in
        make.centerY.equalTo(playButton.snp.centerY)
        make.right.equalTo(slider.snp.right)
      }

    }

  @objc func didTapPlayPause() {
      if let player = player {
          if player.timeControlStatus == .playing {
              player.pause()
            playButton.configureStyleSymbolButton(systemName: "play.circle.fill", pointSize: 80)
            playButton.tintColor = .white
          }
          else if player.timeControlStatus == .paused {
              player.play()
            playButton.configureStyleSymbolButton(systemName: "pause.circle.fill", pointSize: 80)
            playButton.tintColor = .white
          }
        }
  }

  @objc func didTapForward() {
          let moveForword : Float64 = 5

          if player == nil { return }
          if let duration  = player!.currentItem?.duration {
          let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
          let newTime = playerCurrentTime + moveForword
          if newTime < CMTimeGetSeconds(duration)
          {
              let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
              player!.seek(to: selectedTime)
          }
          }
      }

  @objc func didTapBackward() {
              let moveBackword: Float64 = 5
              if player == nil
              {
                  return
              }
              let playerCurrenTime = CMTimeGetSeconds(player!.currentTime())
              var newTime = playerCurrenTime - moveBackword
              if newTime < 0
              {
                  newTime = 0
              }
              let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
              player?.seek(to: selectedTime)

          }


}
