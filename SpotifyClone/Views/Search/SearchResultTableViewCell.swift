//
//  SearchResultCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 13.01.2023.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

  private let contentImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  private let contentName = UILabel()
  private let contentOwner = UILabel()
  let button = UIButton()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    stylee()
    layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func stylee(){
    contentImageView.configureImageView(imageName: "dummyalbum", contentModee: .scaleAspectFill)

    contentName.configureStyle(size: 16, weight: .medium, color: .white)
    contentName.text = "Dark Side Of The Moon"

    contentOwner.configureStyle(size: 14, weight: .light, color: .white)
    contentOwner.text = "Pink Floyd"

    button.configureStyleSymbolButton(systemName: "suit.heart.fill", backgroundClr: nil, cornerRds: nil, tintClr: .systemGreen, pointSize: 20)

  }
  private func layout(){

    contentView.addSubview(contentImageView)
    contentImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(5)
      make.bottom.equalToSuperview().offset(-5)
      make.width.equalTo(50)
      make.height.equalTo(50)
    }

    contentView.addSubview(contentName)
    contentName.snp.makeConstraints { make in
      make.bottom.equalTo(contentView.snp.centerY)
      make.left.equalTo(contentImageView.snp.right).offset(10)
    }

    contentView.addSubview(contentOwner)
    contentOwner.snp.makeConstraints { make in
      make.top.equalTo(contentName.snp.bottom).offset(2)
      make.left.equalTo(contentName.snp.left)
    }

    contentView.addSubview(button)

    button.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.right.equalToSuperview()
    }

  }

  func configure(content:ContentType){

    switch content {
    case .album(let album):
      contentImageView.sd_setImage(with: album.images.first?.url.asURL)
      contentName.text = album.name
      contentOwner.text = album.artists.first?.name
    case .playlist(let playlist):
      contentImageView.sd_setImage(with: playlist.images.first?.url.asURL)
      contentName.text = playlist.name
      contentOwner.text = playlist.owner.displayName
    case .track(let track):
      contentImageView.sd_setImage(with: track.album?.images.first?.url.asURL)
      contentName.text = track.name
      contentOwner.text = track.artists.first?.name
    case .artist(let artist):
      contentImageView.sd_setImage(with: artist.images?.first?.url.asURL)
      contentName.text = artist.name
      contentOwner.text = ""
    }
  }
  
}
