//
//  Button + Extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation
import UIKit

extension UIButton {

  func configureStyle(title:String,titleColor:UIColor,backgroundClr:UIColor?=nil,cornerRds:CGFloat?=nil) {
    translatesAutoresizingMaskIntoConstraints = false
    setTitle(title, for: .normal)
    setTitleColor(titleColor, for: .normal)
    backgroundColor = backgroundClr
    clipsToBounds = true
    layer.cornerRadius = cornerRds ?? 0
    
  }
}

