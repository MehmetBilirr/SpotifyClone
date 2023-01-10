//
//  HomeHeadersCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 10.01.2023.
//

import UIKit

class HomeHeadersCollectionReusableView: UICollectionReusableView {

  static let identifier = "HomeHeadersCollectionReusableView"

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
  headerLabel.configureStyle(size: 22, weight: .bold, color: .white)
  headerLabel.snp.makeConstraints { make in
    make.left.equalToSuperview()
    make.top.equalToSuperview()
  }

  }

  func configure(with title: String) {
      headerLabel.text = title
  }
}
