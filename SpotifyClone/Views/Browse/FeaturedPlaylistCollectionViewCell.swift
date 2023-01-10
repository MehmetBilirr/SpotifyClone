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
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()

  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")

  }
  private func setup(){

    contentView.addSubview(albumImageView)
    albumImageView.configureImageView(imageName: "dummyalbum")
    albumImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func configure(model:SpotifyModel.PlaylistModel){
    albumImageView.sd_setImage(with: model.image.asURL)
  }


}
