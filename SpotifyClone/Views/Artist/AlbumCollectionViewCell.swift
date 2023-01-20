//
//  NewReleasesCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 7.01.2023.
//


import UIKit
import SnapKit
import UIKit
import SnapKit

class AlbumCollectionViewCell: UICollectionViewCell {

  private let albumImageView = UIImageView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func style(){
    albumImageView.configureImageView(contentModee: .scaleAspectFill)


  }
  private func layout(){

    contentView.addSubview(albumImageView)
    albumImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }


  }

  func configure(album:Album){
    albumImageView.sd_setImage(with: album.images.first?.url.asURL)

  }
}
