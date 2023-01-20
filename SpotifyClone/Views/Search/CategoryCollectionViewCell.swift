//
//  CategoriesCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 12.01.2023.
//

import UIKit
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {

  private let categoryImageView = UIImageView()
  private let categoryName = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func style(){
    categoryImageView.configureImageView(contentModee: .scaleAspectFill)

    categoryName.configureStyle(size: 20, weight: .bold, color: .white)


  }
  private func layout(){

    contentView.addSubview(categoryImageView)
    categoryImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    contentView.addSubview(categoryName)

    categoryName.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(5)
      make.bottom.right.equalToSuperview()

    }

  }

  func configure(category:Category){
    categoryImageView.sd_setImage(with: category.icons.first?.url.asURL)
    categoryName.text = category.name
  }
}
