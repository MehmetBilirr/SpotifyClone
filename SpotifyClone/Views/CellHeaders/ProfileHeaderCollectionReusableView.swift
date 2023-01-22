//
//  ProfileHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 22.01.2023.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
  private let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
  private let userNameLbl = UILabel()
  private let followersLbl = UILabel()
  private let followersCountLbl = UILabel()
  private let followingLbl = UILabel()
  private let followingCountLbl = UILabel()
  private let headerLabel = UILabel()
  static let identifier = "ProfileHeaderCollectionReusableView"
  override init(frame: CGRect) {
      super.init(frame: frame)
    style()
    layout()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  private func style(){

    profileImageView.configureImageView(imageName: "dummyalbum", contentModee: .scaleAspectFit)
    userNameLbl.configureStyle(size: 18, weight: .bold, color: .white)
    userNameLbl.text = "Mehmet Bilir"

    followersCountLbl.configureStyle(size: 14, weight: .bold, color: .white)
    followersCountLbl.text  = "24"
    followersLbl.configureStyle(size: 12, weight: .light, color: .white)
    followersLbl.text = "Followers"

    followingCountLbl.configureStyle(size: 14, weight: .bold, color: .white)
    followingCountLbl.text = "29"
    followingLbl.configureStyle(size: 12, weight: .light, color: .white)
    followingLbl.text = "Following"

    headerLabel.configureStyle(size: 18, weight: .bold, color: .white)
    headerLabel.text = "Playlists"

  }
  private func layout(){
    addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(20)
      make.top.equalToSuperview().offset(20)
      make.width.height.equalTo(200)
    }
    addSubview(userNameLbl)
    userNameLbl.snp.makeConstraints { make in
      make.left.equalTo(profileImageView.snp.right).offset(10)
      make.centerY.equalTo(profileImageView.snp.centerY)
    }
    addSubview(followersCountLbl)

    followersCountLbl.snp.makeConstraints { make in
      make.left.equalTo(userNameLbl.snp.left)
      make.top.equalTo(userNameLbl.snp.bottom).offset(5)
    }
    addSubview(followersLbl)
    followersLbl.snp.makeConstraints { make in
      make.left.equalTo(followersCountLbl.snp.right).offset(2)
      make.bottom.equalTo(followersCountLbl.snp.bottom)
    }

    addSubview(followingCountLbl)
    followingCountLbl.snp.makeConstraints { make in
      make.left.equalTo(followersLbl.snp.right).offset(5)
      make.top.equalTo(userNameLbl.snp.bottom).offset(5)
    }
    addSubview(followingLbl)
    followingLbl.snp.makeConstraints { make in
      make.left.equalTo(followingCountLbl.snp.right).offset(2)
      make.bottom.equalTo(followingCountLbl.snp.bottom)
    }
    addSubview(headerLabel)
    headerLabel.snp.makeConstraints { make in
      make.left.equalToSuperview()
      make.bottom.equalToSuperview()
    }

  }

  func configure(user:UserProfile) {
    profileImageView.sd_setImage(with: user.images.first?.url.asURL)
    userNameLbl.text = user.display_name
    followersCountLbl.text = String(user.followers.total)

  }

}

