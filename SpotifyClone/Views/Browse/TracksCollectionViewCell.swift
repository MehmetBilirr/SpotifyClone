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

    albumImageView.configureImageView(imageName: "dummyalbum")

    albumNamelbl.configureStyle(size: 18, weight: .semibold, color: .white)
    albumNamelbl.text = "Dark Side Of the Moon"

    artistNameLbl.configureStyle(size: 18, weight: .thin, color: .white)
    artistNameLbl.text = "Pink Floyd"
  }

  private func layout(){

    contentView.addSubview(albumImageView)
    albumImageView.snp.makeConstraints { make in
      make.top.left.equalToSuperview().offset(5)
      make.bottom.equalToSuperview().offset(-10)
      make.width.equalTo(40)

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
}
