//
//  ArtistHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 19.01.2023.
//

import UIKit

import UIKit

class ArtistHeaderCollectionReusableView: UICollectionReusableView {

  static let identifier = "ArtistHeaderCollectionReusableView"

  private let headerLabel = UILabel()
  private let imageView = UIImageView()
  private let artistLbl = UILabel()
  override init(frame: CGRect) {
      super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  private func setup(){

    addSubview(imageView)
    imageView.configureImageView(contentModee: .scaleAspectFill)

    imageView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.equalToSuperview().offset(-130)
      make.height.equalTo(200)
    }

    addSubview(artistLbl)
    artistLbl.configureStyle(size: 30, weight: .bold, color: .white)
    artistLbl.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalTo(imageView.snp.bottom)
    }

    addSubview(headerLabel)
  headerLabel.configureStyle(size: 18, weight: .bold, color: .white)
  headerLabel.snp.makeConstraints { make in
    make.left.equalToSuperview()
    make.top.equalTo(imageView.snp.bottom).offset(20)
  }

  }

  func configure(headerTitle: String,artist:Artist?=nil) {

    headerLabel.text = headerTitle
    imageView.sd_setImage(with: artist?.images?.first?.url.asURL)
    artistLbl.text = artist?.name
  }
}
