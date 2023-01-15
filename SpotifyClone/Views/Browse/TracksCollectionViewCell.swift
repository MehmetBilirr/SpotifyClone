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
  private let albumNamelbl = UILabel()
  private let artistNameLbl = UILabel()
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

    albumNamelbl.configureStyle(size: 18, weight: .semibold, color: .white)
    

    artistNameLbl.configureStyle(size: 18, weight: .thin, color: .white)

  }

  private func layout(){

    contentView.addSubview(albumImageView)
    albumImageView.snp.makeConstraints { make in
      make.top.left.equalToSuperview().offset(5)
      make.width.equalTo(40)
      make.height.equalTo(40)

    }

    contentView.addSubview(albumNamelbl)

    albumNamelbl.snp.makeConstraints { make in
      make.left.equalTo(albumImageView.snp.right).offset(20)
      make.top.equalTo(albumImageView.snp.top)
    }

    contentView.addSubview(artistNameLbl)
    artistNameLbl.snp.makeConstraints { make in
      make.left.equalTo(albumNamelbl.snp.left)
      make.bottom.equalTo(albumImageView.snp.bottom)
    }
  }

  func configure(track:Track){
    albumImageView.sd_setImage(with: track.album?.images.first?.url.asURL)
    albumNamelbl.text = track.name
    artistNameLbl.text = track.artists.first?.name
  }
}
