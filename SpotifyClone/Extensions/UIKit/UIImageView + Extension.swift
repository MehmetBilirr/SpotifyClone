//
//  UIImageView + extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation
import UIKit

extension UIImageView {

  func configureCustomImageView(imageName:String,cornerRds:CGFloat?=nil){
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = cornerRds ?? 0
    contentMode = .scaleAspectFit
    clipsToBounds = true
    layer.masksToBounds = true
    image = UIImage(named: imageName)

  }

}
