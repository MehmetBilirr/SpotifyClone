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
  func configureBarButtons()


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
      slider.maximumValue = 29
      slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
      return slider
  }()
  private let imageView = UIImageView()
  var player : AVPlayer
  private var playerItem:AVPlayerItem?
  var track:Track?
  var isPlaying : Bool? {
    didSet{
      playButton.configureStyleSymbolButton(systemName: isPlaying  == true ? "pause.circle.fill" : "play.circle.fill" ,tintClr: .white, pointSize: 80)
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()

      style()
      layout()
      configurePlayer()
      configureBarButtons()

    }

  init(track:Track,player:AVPlayer,isPlaying:Bool){
    self.track = track
    self.player = player

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewWillDisappear(_ animated: Bool) {
    view.isHidden = true
  }
  override func viewWillAppear(_ animated: Bool) {
    view.isHidden = false
  }
}
extension PlayerViewController:PlayerViewInterface {

  func configureBarButtons() {
    let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .done, target: self, action: #selector(didTapCloseButton))
    leftBarButton.tintColor = .white
    navigationItem.leftBarButtonItem = leftBarButton

    let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: nil)
    rightBarButton.tintColor = .gray
    navigationItem.rightBarButtonItem = rightBarButton
  }

  func configurePlayer() {


    self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { [weak self] (time) in
            if self?.player.currentItem?.status == .readyToPlay {
              let currentTime = CMTimeGetSeconds(self?.player.currentTime() ?? CMTime())

                let secs = Int(currentTime)
              self?.slider.value = Float(secs)
                self?.currentTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
        }
    })
  }

  @objc func didTapCloseButton(){

    dismiss(animated: true)
  }
  
  func style() {
    view.backgroundColor = .black
    title = track?.album?.name

    let currentTime = CMTimeGetSeconds(self.player.currentTime() ?? CMTime())
    let secs = Int(currentTime)

    slider.value = Float(secs)


    imageView.configureImageView(contentModee: .scaleAspectFit)
    imageView.sd_setImage(with: track?.album?.images.first?.url.asURL)

    trackNameLbl.configureStyle(size: 20, weight: .bold, color: .white)
    trackNameLbl.text = track?.name

    artistLbl.configureStyle(size: 15, weight: .thin, color: .white)
    artistLbl.text = track?.artists.first?.name

    currentTimeLbl.configureStyle(size: 14, weight: .thin, color: .gray)
    currentTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String

    totalTimeLbl.configureStyle(size: 14, weight: .thin, color: .gray)
    totalTimeLbl.text = "0.29"

    shuffleButton.configureStyleSymbolButton(systemName: "shuffle", tintClr: .white,pointSize: 30)


    backwardButton.configureStyleSymbolButton(systemName: "backward.end.fill", tintClr: .white, pointSize: 40)
    backwardButton.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)

    playButton.configureStyleSymbolButton(systemName: isPlaying == true ?  "pause.circle.fill" : "play.circle.fill" , tintClr: .white, pointSize: 80)
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

    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(30)
      make.right.equalToSuperview().offset(-30)
      make.top.equalToSuperview().offset(100)
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
   NotificationCenter.default.post(name: .didTapVCPlayButton, object: nil)
          if player.timeControlStatus == .playing {
              player.pause()
            isPlaying = false
          }
          else if player.timeControlStatus == .paused {
              player.play()
            isPlaying = true
          }

  }

  @objc func didTapForward() {
          let moveForword : Float64 = 5

          if player == nil { return }
          if let duration  = player.currentItem?.duration {
          let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
          let newTime = playerCurrentTime + moveForword
          if newTime < CMTimeGetSeconds(duration)
          {
              let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
              player.seek(to: selectedTime)
          }
          }
      }

  @objc func didTapBackward() {
              player.seek(to: .zero)

          }


}
