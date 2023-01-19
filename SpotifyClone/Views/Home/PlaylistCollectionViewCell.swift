//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 7.01.2023.
//

import UIKit
import SnapKit

class PlaylistCollectionViewCell: UICollectionViewCell {
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
    contentView.addSubview(descriptionLbl)
    descriptionLbl.configureStyle(size: 14, weight: .thin, color: .white)
    descriptionLbl.numberOfLines = 2
    descriptionLbl.lineBreakMode = .byTruncatingTail

    albumImageView.configureImageView(contentModee: .scaleAspectFill)
    contentView.addSubview(albumImageView)


    albumImageView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.bottom.equalToSuperview().offset(-10)
    }

    descriptionLbl.snp.makeConstraints { make in
      make.top.equalTo(albumImageView.snp.bottom)
      make.left.right.equalToSuperview()
    }


  }

  func configure(playlist:Playlist){
    descriptionLbl.text = playlist.itemDescription
    albumImageView.sd_setImage(with: playlist.images.first?.url.asURL)
  }


}
