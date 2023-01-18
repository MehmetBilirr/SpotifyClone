//
//  PlayerViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 18.01.2023.
//

import UIKit
import SnapKit

protocol PlayerViewInterface {

  func style()
  func layout()
  func configureNavBars()


}

private let shuffleButton = UIButton()
private let backwardButton = UIButton()
private let playButton = UIButton()
private let forwardButton = UIButton()
private let repeatButton = UIButton()
private let trackNameLbl = UILabel()
private let artistLbl = UILabel()
private let currentTimeLbl = UILabel()
private let totalTimeLbl = UILabel()
private let slider: UISlider = {
    let slider = UISlider()
    slider.value = 0
    slider.tintColor = .white
    slider.maximumValue = 30
  slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
    return slider
}()
class PlayerViewController: UIViewController {
    private let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

      style()
      layout()
      configureNavBars()

    }
}

extension PlayerViewController:PlayerViewInterface {

  func configureNavBars() {
    let downArrow = UIImage(systemName: "chevron.down")
    let leftBarButton = UIBarButtonItem(image: downArrow, style:.done , target: self, action: #selector(didTapCloseButton))
    leftBarButton.tintColor = .white

    navigationItem.leftBarButtonItem = leftBarButton

    let threeDots = UIImage(systemName: "ellipsis")
    let rightBarButton = UIBarButtonItem(image: threeDots, style:.done , target: self, action: nil)
    rightBarButton.tintColor = .white
    navigationItem.rightBarButtonItem = rightBarButton

  }

  @objc func didTapCloseButton(){
    slider.value += 0.1
  }
  
  func style() {
    imageView.configureImageView(imageName: "dummyalbum", contentModee: .scaleAspectFill)

    trackNameLbl.configureStyle(size: 20, weight: .bold, color: .white)
    trackNameLbl.text = "Comfortably Numb"

    artistLbl.configureStyle(size: 15, weight: .thin, color: .white)
    artistLbl.text = "Pink Floyd"

    currentTimeLbl.configureStyle(size: 12, weight: .thin, color: .gray)
    currentTimeLbl.text = "0.00"

    totalTimeLbl.configureStyle(size: 12, weight: .thin, color: .gray)
    totalTimeLbl.text = "0.30"

    shuffleButton.configureStyleSymbolButton(systemName: "shuffle", tintClr: .white)


    backwardButton.configureStyleSymbolButton(systemName: "backward.end.fill", tintClr: .white)

    playButton.configureStyleSymbolButton(systemName: "play.circle.fill", tintClr: .white)

    forwardButton.configureStyleSymbolButton(systemName: "forward.end.fill", tintClr: .white)

    repeatButton.configureStyleSymbolButton(systemName: "arrow.rectanglepath", tintClr: .white)

  }

  func layout() {

    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(30)
      make.right.equalToSuperview().offset(-30)
      make.top.equalTo(view.safeAreaInsets.top).offset(100)
      make.height.equalTo(view.height / 2.3)
    }

    view.addSubview(trackNameLbl)
    trackNameLbl.snp.makeConstraints { make in
      make.left.equalTo(imageView.snp.left).offset(-10)
      make.top.equalTo(imageView.snp.bottom).offset(20)
    }

    view.addSubview(artistLbl)
    artistLbl.snp.makeConstraints { make in
      make.left.equalTo(trackNameLbl.snp.left)
      make.top.equalTo(trackNameLbl.snp.bottom).offset(2)
    }
    view.addSubview(slider)
    slider.snp.makeConstraints { make in
      make.left.equalTo(trackNameLbl.snp.left)
      make.right.equalTo(imageView.snp.right).offset(10)
      make.top.equalTo(artistLbl.snp.bottom).offset(20)

    }

    view.addSubview(currentTimeLbl)
    currentTimeLbl.snp.makeConstraints { make in
      make.left.equalTo(trackNameLbl.snp.left)
      make.top.equalTo(slider.snp.bottom).offset(2)
    }

    view.addSubview(totalTimeLbl)
    totalTimeLbl.snp.makeConstraints { make in
      make.right.equalTo(slider.snp.right)
      make.top.equalTo(slider.snp.bottom).offset(2)
    }

    view.addSubview(shuffleButton)
    shuffleButton.snp.makeConstraints { make in
      make.top.equalTo(totalTimeLbl.snp.bottom).offset(30)
      make.left.equalTo(trackNameLbl.snp.left)
    }

    view.addSubview(backwardButton)
    backwardButton.snp.makeConstraints { make in
      backwardButton.snp.makeConstraints { make in
        make.top.equalTo(totalTimeLbl.snp.bottom).offset(30)
        make.left.equalTo(shuffleButton.snp.left).offset(50)
      }
    }
  }


}
