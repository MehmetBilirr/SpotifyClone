//
//  AlbumDetailsCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import UIKit

class ContentetailsCollectionViewCell: UICollectionViewCell {
  let trackNamelbl = UILabel()
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

    trackNamelbl.configureStyle(size: 15, weight: .semibold, color: .white)
    trackNamelbl.numberOfLines = 1

    artistNameLbl.configureStyle(size: 15, weight: .thin, color: .white)

    moreButton.configureStyleTitleButton(title: "...", titleColor: .gray)
  }

  private func layout(){


    contentView.addSubview(trackNamelbl)

    trackNamelbl.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(5)

      make.centerY.equalTo(contentView.snp.centerY)
    }

    contentView.addSubview(artistNameLbl)
    artistNameLbl.snp.makeConstraints { make in
      make.left.equalTo(trackNamelbl.snp.left)
      make.right.equalToSuperview()
      make.top.equalTo(trackNamelbl.snp.bottom)
    }
    
    contentView.addSubview(moreButton)
    moreButton.snp.makeConstraints { make in
      make.centerY.equalTo(trackNamelbl.snp.centerY)
      make.right.equalToSuperview()
    }
  }

  func configure(track:Track){

    trackNamelbl.text = track.name
    artistNameLbl.text = track.artists.first?.name
  }
}
