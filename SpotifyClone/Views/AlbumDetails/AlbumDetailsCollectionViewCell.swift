//
//  AlbumDetailsCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import UIKit

class AlbumDetailsCollectionViewCell: UICollectionViewCell {
  private let albumNamelbl = UILabel()
  private let artistNameLbl = UILabel()
  private let moreButton = UIButton()
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()

  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")

  }

  private func style(){

    albumNamelbl.configureStyle(size: 18, weight: .semibold, color: .white)


    artistNameLbl.configureStyle(size: 18, weight: .thin, color: .white)

    moreButton.configureStyleTitleButton(title: "...", titleColor: .gray)
  }

  private func layout(){


    contentView.addSubview(albumNamelbl)

    albumNamelbl.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(5)
      make.centerY.equalTo(contentView.snp.centerY)
    }

    contentView.addSubview(artistNameLbl)
    artistNameLbl.snp.makeConstraints { make in
      make.left.equalTo(albumNamelbl.snp.left)
      make.top.equalTo(albumNamelbl.snp.bottom)
    }
    
    contentView.addSubview(moreButton)
    moreButton.snp.makeConstraints { make in
      make.centerY.equalTo(albumNamelbl.snp.centerY)
      make.right.equalToSuperview()
    }
  }

  func configure(track:SpotifyModel.TrackModel){
    albumNamelbl.text = track.name
    artistNameLbl.text = track.artistName
  }
}
