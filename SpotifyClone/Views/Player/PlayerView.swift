//
//  PlayerView.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 21.01.2023.
//

import UIKit
import SnapKit

class PlayerView: UIView {
  let trackImageView  = UIImageView()
  let trackNameLbl = UILabel()
  let artistNameLbl = UILabel()
  let playButton = UIButton()
  var isPlaying = false
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func style(){
    backgroundColor = .systemGray6
    trackImageView.configureImageView(contentModee: .scaleAspectFit)
    trackNameLbl.configureStyle(size: 14, weight: .bold, color: .white)
    artistNameLbl.configureStyle(size: 12, weight: .light, color: .white)
    playButton.configureStyleSymbolButton(systemName:"play.fill", backgroundClr: nil, cornerRds: nil, tintClr: .white, pointSize: 20)
    playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)

  }

  @objc func didTapPlayButton(){
    isPlaying = !isPlaying
    playButton.configureStyleSymbolButton(systemName: isPlaying == true ? "pause.fill" : "play.fill", backgroundClr: nil, cornerRds: nil, tintClr: .white, pointSize: 20)
    NotificationCenter.default.post(name: .didTapPlayButton, object: nil)
    

  }

  private func layout(){
    addSubview(trackImageView)
    trackImageView.snp.makeConstraints { make in
      make.left.top.equalToSuperview().offset(5)
      make.bottom.equalToSuperview().offset(-5)
      make.width.equalTo(44)
    }

    addSubview(trackNameLbl)
    trackNameLbl.snp.makeConstraints { make in
      make.left.equalTo(trackImageView.snp.right).offset(10)
      make.bottom.equalTo(self.snp.centerY)
    }

    addSubview(artistNameLbl)
    artistNameLbl.snp.makeConstraints { make in
      make.left.equalTo(trackNameLbl.snp.left)
      make.top.equalTo(trackNameLbl.snp.bottom)
    }
    addSubview(playButton)
    playButton.snp.makeConstraints { make in
      make.right.top.equalToSuperview()
      make.right.equalToSuperview().offset(-5)
      make.height.equalTo(46)
    }
    

  }

  func configure(track:Track){
    trackImageView.sd_setImage(with: track.album?.images.first?.url.asURL)
    trackNameLbl.text = track.name
    artistNameLbl.text = track.artists.first?.name
  }
}
