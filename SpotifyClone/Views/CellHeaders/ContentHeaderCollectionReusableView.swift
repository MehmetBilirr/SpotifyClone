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
  private let albumCoverImageView = UIImageView()
  private let playButton = UIButton()
  private let nameLbl = UILabel()
  private let artstLbl = UILabel()
  private let descriptionLbl = UILabel()
  private let likeButton = UIButton()
  private let downloadButton = UIButton()
  private let dotButton  = UIButton()
  private let shuffleButton = UIButton()
  private let artistImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func style(){

    albumCoverImageView.configureImageView(contentModee: .scaleAspectFit)

    artistImageView.configureImageView(contentModee: .scaleAspectFit)

    nameLbl.configureStyle(size: 20, weight: .bold, color: .white)

    artstLbl.configureStyle(size: 13, weight: .bold, color: .white)

    descriptionLbl.configureStyle(size: 14, weight: .thin, color: .white)
    descriptionLbl.numberOfLines = 1
    descriptionLbl.lineBreakMode = .byTruncatingTail

    playButton.configureStyleSymbolButton(systemName: "play.fill", backgroundClr: .systemGreen, cornerRds: 25, tintClr: .black, pointSize: 20)

    likeButton.configureStyleSymbolButton(systemName: "suit.heart", tintClr: .gray,pointSize: 20)

    downloadButton.configureStyleSymbolButton(systemName: "arrow.down.circle",tintClr: .gray,pointSize: 20)

    dotButton.configureStyleSymbolButton(systemName: "ellipsis", tintClr: .gray, pointSize: 20)

    shuffleButton.configureStyleSymbolButton(systemName: "shuffle", tintClr: .gray,pointSize: 25)


  }

  private func layout(){
    addSubview(albumCoverImageView)
    albumCoverImageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(70)
      make.right.equalToSuperview().offset(-70)
      make.top.equalToSuperview().offset(-75)
      make.height.equalTo(height / 1.2)
    }

    addSubview(nameLbl)
    nameLbl.snp.makeConstraints { make in
      make.top.equalTo(albumCoverImageView.snp.bottom).offset(10)
      make.left.equalToSuperview().offset(5)

    }

    addSubview(artistImageView)
    artistImageView.snp.makeConstraints { make in
      make.left.equalTo(nameLbl.snp.left)
      make.bottom.equalTo(nameLbl.snp.bottom).offset(20)
      make.height.width.equalTo(15)
    }

    addSubview(artstLbl)
    artstLbl.snp.makeConstraints { make in
      make.left.equalTo(artistImageView.snp.right).offset(5)
      make.centerY.equalTo(artistImageView.snp.centerY)


    }
    addSubview(descriptionLbl)
    descriptionLbl.snp.makeConstraints { make in
      make.left.equalTo(nameLbl.snp.left)
      make.top.equalTo(artistImageView.snp.bottom).offset(5)
      make.right.equalTo(self.snp.centerX).offset(100)
    }

    addSubview(playButton)
    playButton.snp.makeConstraints { make in
      make.right.bottom.equalToSuperview()
      make.height.width.equalTo(50)
    }

    addSubview(likeButton)
    likeButton.snp.makeConstraints { make in
      make.left.equalTo(nameLbl.snp.left)
      make.centerY.equalTo(playButton.snp.centerY)
    }

    addSubview(downloadButton)
    downloadButton.snp.makeConstraints { make in
      make.left.equalTo(likeButton.snp.right).offset(10)
      make.centerY.equalTo(playButton.snp.centerY)
    }

    addSubview(dotButton)
    dotButton.snp.makeConstraints { make in
      make.left.equalTo(downloadButton.snp.right).offset(10)
      make.centerY.equalTo(playButton.snp.centerY)
    }

    addSubview(shuffleButton)
    shuffleButton.snp.makeConstraints { make in
      make.right.equalTo(playButton.snp.left).offset(-10)
      make.centerY.equalTo(playButton.snp.centerY)
    }
  }

  func configure(content:ContentType){

    switch content {

    case .album(let album):

      albumCoverImageView.sd_setImage(with: album.images.first?.url.asURL)
      nameLbl.text = album.name
      artstLbl.text = album.artists.first?.name
      descriptionLbl.text = String.formattedDate(string: album.releaseDate)
      artistImageView.sd_setImage(with: album.images.first?.url.asURL)
    case .playlist(let playlist):
      albumCoverImageView.sd_setImage(with: playlist.images.first?.url.asURL)
      nameLbl.text = playlist.name
      descriptionLbl.text = playlist.itemDescription.description
      artstLbl.text = playlist.owner.displayName
      artistImageView.image = UIImage(named: "logo")
    default:
      break

    }

  }
}
