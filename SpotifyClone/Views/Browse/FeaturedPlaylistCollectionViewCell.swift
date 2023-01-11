//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 7.01.2023.
//

import UIKit
import SnapKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
  private let albumImageView = UIImageView()
  private let descriptionLbl = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()

  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")

  }
  private func setup(){

    descriptionLbl.configureStyle(size: 14, weight: .thin, color: .white)
    descriptionLbl.numberOfLines = 2
    descriptionLbl.lineBreakMode = .byTruncatingTail

    contentView.addSubview(descriptionLbl)
    contentView.addSubview(albumImageView)
    albumImageView.configureImageView(contentModee: .scaleAspectFill)

    descriptionLbl.snp.makeConstraints { make in
      make.top.equalTo(albumImageView.snp.bottom)
      make.left.right.equalToSuperview()
    }

    albumImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func configure(model:SpotifyModel.PlaylistModel){
    descriptionLbl.text = model.description
    albumImageView.sd_setImage(with: model.image.asURL)
  }


}
