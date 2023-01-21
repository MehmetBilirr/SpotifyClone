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
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func style(){
    backgroundColor = .black
    trackImageView.configureImageView(imageName: "dummyalbum", contentModee: .scaleAspectFit)
    trackNameLbl.configureStyle(size: 14, weight: .bold, color: .white)
    trackNameLbl.text = "Dark Side Of The Moon"
    artistNameLbl.configureStyle(size: 12, weight: .light, color: .white)
    artistNameLbl.text = "Pink FLoyd"
  }

  private func layout(){
    addSubview(trackImageView)
    trackImageView.snp.makeConstraints { make in
      make.left.top.equalToSuperview().offset(4)
      make.bottom.equalToSuperview().offset(-4)
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
    

  }

  func configure(track:Track){
    trackImageView.sd_setImage(with: track.album?.images.first?.url.asURL)
    trackNameLbl.text = track.name
    artistNameLbl.text = track.artists.first?.name
  }
}
