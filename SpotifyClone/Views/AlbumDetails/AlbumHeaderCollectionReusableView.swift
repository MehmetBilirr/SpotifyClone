//
//  AlbumHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import UIKit
import SnapKit

class AlbumHeaderCollectionReusableView: UICollectionReusableView {
  static let identifier = "AlbumHeaderCollectionReusableView"
  private let albumImageView = UIImageView()
  private let playButton = UIButton()
  private let albumNameLbl = UILabel()
  private let dateLbl = UILabel()
  private let artistLbl = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func style(){

    albumImageView.configureImageView(contentModee: .scaleAspectFit)

    albumNameLbl.configureStyle(size: 20, weight: .bold, color: .white)
    albumNameLbl.text = "Dark Side Of The Moon"

    dateLbl.configureStyle(size: 18, weight: .thin, color: .white)
    dateLbl.text = "Release Date: 8 May 1972"

    artistLbl.configureStyle(size: 18, weight: .thin, color: .white)
    artistLbl.text = "Pink Floyd"

    playButton.configureStyleSymbolButton(systemName: "play.fill", backgroundClr: .systemGreen, cornerRds: 25, tintClr: .black)


  }

  private func layout(){
    addSubview(albumImageView)
    albumImageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(70)
      make.right.equalToSuperview().offset(-70)
      make.top.equalToSuperview()
      make.height.equalTo(height / 1.3)
    }

    addSubview(playButton)
    playButton.snp.makeConstraints { make in
      make.centerX.equalTo(albumImageView.snp.right)
      make.centerY.equalTo(albumImageView.snp.bottom)
      make.height.width.equalTo(50)
    }

    addSubview(albumNameLbl)
    albumNameLbl.snp.makeConstraints { make in
      make.top.equalTo(albumImageView.snp.bottom).offset(10)
      make.left.equalToSuperview().offset(5)
    }

    addSubview(dateLbl)
    dateLbl.snp.makeConstraints { make in
      make.left.equalTo(albumNameLbl.snp.left)
      make.top.equalTo(albumNameLbl.snp.bottom).offset(5)
    }

    addSubview(artistLbl)
    artistLbl.snp.makeConstraints { make in
      make.left.equalTo(albumNameLbl.snp.left)
      make.top.equalTo(dateLbl.snp.bottom).offset(5)
    }

  }


  func configure(album:Album){
    albumImageView.sd_setImage(with: album.images.first?.url.asURL)
    albumNameLbl.text = album.name
    dateLbl.text = "Release Date: \(album.releaseDate)"
    artistLbl.text = album.artists.first?.name ?? ""

  }


}
