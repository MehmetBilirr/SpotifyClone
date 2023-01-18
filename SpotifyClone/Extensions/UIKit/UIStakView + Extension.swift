//
//  UIStakView + Extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 18.01.2023.
//

import Foundation
import UIKit


extension UIStackView {

  func configureStyle(_ space:CGFloat,_ views:[UIView],_ axis:NSLayoutConstraint.Axis,_ allignment:Alignment){
    translatesAutoresizingMaskIntoConstraints = false
    spacing = space
    self.axis = axis
    alignment = allignment

  }
}
