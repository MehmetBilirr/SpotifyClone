//
//  UIImageView + extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation
import UIKit

extension UIImageView {

  func configureImageView(imageName:String?=nil,contentModee:UIView.ContentMode){
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = self.frame.width / 2
    contentMode = contentModee
    clipsToBounds = true
    layer.masksToBounds = true
    image = UIImage(named: imageName ?? "")

  }

}
