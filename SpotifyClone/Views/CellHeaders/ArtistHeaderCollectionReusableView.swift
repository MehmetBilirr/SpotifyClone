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

  override init(frame: CGRect) {
      super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  private func setup(){
    addSubview(headerLabel)
  headerLabel.configureStyle(size: 18, weight: .bold, color: .white)
  headerLabel.snp.makeConstraints { make in
    make.left.equalToSuperview()
    make.bottom.equalToSuperview()
  }

  }

  func configure(with title: String) {
      headerLabel.text = title
  }
}
