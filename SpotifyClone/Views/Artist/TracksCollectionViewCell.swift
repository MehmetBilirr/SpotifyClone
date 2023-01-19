//
//  RecommendedTracksCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 7.01.2023.
//

import UIKit
import SnapKit

class TracksCollectionViewCell: UICollectionViewCell {

  private let albumImageView = UIImageView()
  private let trackNameLbl = UILabel()
  private let albumNameLbl = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()

  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")

  }

  private func style(){

    backgroundColor = .systemBackground

    albumImageView.configureImageView(contentModee: .scaleAspectFill)
    albumImageView.image = UIImage(named: "dummyalbum")

    trackNameLbl.configureStyle(size: 18, weight: .semibold, color: .white)
    trackNameLbl.text = "Hey You"

    albumNameLbl.configureStyle(size: 15, weight: .thin, color: .white)
    albumNameLbl.text = "The Wall"

  }

  private func layout(){

    contentView.addSubview(albumImageView)
    albumImageView.snp.makeConstraints { make in
      make.top.left.equalToSuperview().offset(5)
      make.bottom.equalToSuperview()
      make.width.equalTo(50)

    }

    contentView.addSubview(trackNameLbl)
    trackNameLbl.snp.makeConstraints { make in
      make.left.equalTo(albumImageView.snp.right).offset(20)
      make.right.equalToSuperview()
      make.centerY.equalTo(albumImageView.snp.centerY).offset(-10)
    }

    contentView.addSubview(albumNameLbl)
    albumNameLbl.snp.makeConstraints { make in
      make.left.equalTo(trackNameLbl.snp.left)
      make.right.equalToSuperview()
      make.top.equalTo(trackNameLbl.snp.bottom)
    }


  }

  func configure(track:Track){
    albumImageView.sd_setImage(with: track.album?.images.first?.url.asURL)
    trackNameLbl.text = track.name
    albumNameLbl.text = track.album?.name
  }
}
