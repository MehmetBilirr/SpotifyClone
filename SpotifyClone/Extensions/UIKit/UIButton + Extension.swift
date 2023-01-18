//
//  Button + Extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation
import UIKit

extension UIButton {

  func configureStyleTitleButton(title:String,titleColor:UIColor,backgroundClr:UIColor?=nil,cornerRds:CGFloat?=nil) {
    translatesAutoresizingMaskIntoConstraints = false
    setTitle(title, for: .normal)
    setTitleColor(titleColor, for: .normal)
    backgroundColor = backgroundClr
    clipsToBounds = true
    layer.cornerRadius = cornerRds ?? 0
    
  }

  func configureStyleSymbolButton(systemName:String,backgroundClr:UIColor?=nil,cornerRds:CGFloat?=nil,tintClr:UIColor?=nil,pointSize:CGFloat) {
    backgroundColor = backgroundClr
    tintColor = tintClr
    let image = UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: pointSize, weight: .regular))
    setImage(image, for: .normal)
    layer.cornerRadius = cornerRds ?? 0
    layer.masksToBounds = true

  }
}

