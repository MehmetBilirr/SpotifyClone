//
//  RecentlyPlayedCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 13.01.2023.
//

import UIKit

class RecentlyPlayedCollectionViewCell: UICollectionViewCell {

  private let albumImageView = UIImageView()
  private let albumNamelbl = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()

  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")

  }

  private func style(){

    backgroundColor = .secondarySystemBackground

    albumImageView.configureImageView(contentModee: .scaleAspectFill)

    albumNamelbl.configureStyle(size: 12, weight: .semibold, color: .white)
    albumNamelbl.numberOfLines = 2
    albumNamelbl.lineBreakMode = .byTruncatingTail



  }

  private func layout(){

    contentView.addSubview(albumImageView)
    albumImageView.snp.makeConstraints { make in
      make.top.left.bottom.equalToSuperview()
      make.width.equalTo(60)

    }

    contentView.addSubview(albumNamelbl)

    albumNamelbl.snp.makeConstraints { make in
      make.left.equalTo(albumImageView.snp.right).offset(10)
      make.right.equalToSuperview()
      make.centerY.equalTo(albumImageView.snp.centerY)
    }

  }

  func configure(album:Album){
    albumImageView.sd_setImage(with: album.images.first?.url.asURL)
    albumNamelbl.text = album.name

  }
}
