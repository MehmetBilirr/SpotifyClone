//
//  AlbumHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import UIKit
import SnapKit

class ContentHeaderCollectionReusableView: UICollectionReusableView {
  static let identifier = "AlbumHeaderCollectionReusableView"
  private let imageView = UIImageView()
  private let playButton = UIButton()
  private let nameLbl = UILabel()
  private let descriptionLbl = UILabel()
  private let artistLbl = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func style(){

    imageView.configureImageView(contentModee: .scaleAspectFit)

    nameLbl.configureStyle(size: 20, weight: .bold, color: .white)
    nameLbl.text = "Dark Side Of The Moon"

    descriptionLbl.configureStyle(size: 15, weight: .thin, color: .white)
    descriptionLbl.text = "Release Date: 8 May 1972"

    artistLbl.configureStyle(size: 15, weight: .thin, color: .white)
    artistLbl.text = "Pink Floyd"

    playButton.configureStyleSymbolButton(systemName: "play.fill", backgroundClr: .systemGreen, cornerRds: 25, tintClr: .black, pointSize: 20)


  }

  private func layout(){
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(70)
      make.right.equalToSuperview().offset(-70)
      make.top.equalToSuperview()
      make.height.equalTo(height / 1.3)
    }



    addSubview(nameLbl)
    nameLbl.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(10)
      make.left.equalToSuperview().offset(5)

    }
    addSubview(playButton)
    playButton.snp.makeConstraints { make in
      make.right.equalToSuperview()
      make.top.equalTo(nameLbl.snp.bottom)
      make.height.width.equalTo(50)
    }

    addSubview(descriptionLbl)
    descriptionLbl.snp.makeConstraints { make in
      make.left.equalTo(nameLbl.snp.left)
      make.top.equalTo(nameLbl.snp.bottom).offset(5)
      make.right.equalTo(playButton.snp.left)
    }

    addSubview(artistLbl)
    artistLbl.snp.makeConstraints { make in
      make.left.equalTo(nameLbl.snp.left)
      make.top.equalTo(descriptionLbl.snp.bottom).offset(5)
      make.bottom.equalToSuperview()
    }

  }


  func configure(content:ContentType){
    switch content {
    case .album(let album):
      imageView.sd_setImage(with: album.images.first?.url.asURL)
      nameLbl.text = album.name
      descriptionLbl.text = "Release Date: \(String.formattedDate(string: album.releaseDate))"
      artistLbl.text = album.artists.first?.name ?? ""
    case .playlist(let playlist):
      imageView.sd_setImage(with: playlist.images.first?.url.asURL)
      nameLbl.text = playlist.name
      artistLbl.text = playlist.owner.displayName
      descriptionLbl.text = playlist.itemDescription

    default:
      break

    }


  }


}
