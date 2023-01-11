//
//  NewReleasesCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 7.01.2023.
//


import UIKit
import SnapKit
class NewReleasesCollectionViewCell: UICollectionViewCell {
  private let albumImageView = UIImageView()
  private let albumNamelbl = UILabel()
  private let artistNameLbl = UILabel()
  private let trackCountLbl = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()

  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")

  }

  private func style(){

    layer.cornerRadius = 20
    clipsToBounds = true
    backgroundColor = .secondarySystemBackground


    albumImageView.configureImageView(contentModee: .scaleAspectFill)
    albumImageView.layer.cornerRadius = 20
    artistNameLbl.configureStyle(size: 18, weight: .light, color: .white)
    artistNameLbl.text = "Pink Floyd"

    albumNamelbl.configureStyle(size: 20, weight: .semibold, color: .white)
    albumNamelbl.text = "Dark Side Of The Moon"

    trackCountLbl.configureStyle(size: 15, weight: .thin, color: .white)
    trackCountLbl.text = "Tracks: 10"


  }

  private func layout(){
    contentView.addSubview(albumImageView)
    albumImageView.snp.makeConstraints { make in
      make.left.top.equalToSuperview().offset(2)
      make.bottom.equalToSuperview().offset(-2)
      make.width.equalTo(100)
    }

    contentView.addSubview(artistNameLbl)
    artistNameLbl.snp.makeConstraints { make in
      make.left.equalTo(albumImageView.snp.right).offset(10)
      make.centerY.equalTo(contentView.snp.centerY)
    }

    contentView.addSubview(albumNamelbl)
    albumNamelbl.snp.makeConstraints { make in
      make.left.equalTo(artistNameLbl.snp.left)
      make.bottom.equalTo(artistNameLbl.snp.top).offset(-5)
    }

    contentView.addSubview(trackCountLbl)
    trackCountLbl.snp.makeConstraints { make in
      make.left.equalTo(artistNameLbl.snp.left)
      make.top.equalTo(artistNameLbl.snp.bottom).offset(5)
    }

  }

   func configure(album:SpotifyModel.NewReleaseModel) {

    albumNamelbl.text = album.name
    artistNameLbl.text = album.artistName
    albumImageView.sd_setImage(with: album.image.asURL)
    trackCountLbl.text = String(album.numberOfTracks)
  }


}
