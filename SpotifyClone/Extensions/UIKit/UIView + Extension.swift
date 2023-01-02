//
//  UIView + Extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation

import Foundation
import UIKit

extension UIView {

    public var width:CGFloat {
        return self.frame.size.width
    }

    public var height:CGFloat {
        return self.frame.size.height
    }

    public var top:CGFloat {
        return self.frame.origin.y
    }

    public var bottom:CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }

    public var left:CGFloat {
        return self.frame.origin.x
    }

    public var right:CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }

    func configureBetweenView(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemFill
        heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

}


extension UIView {

    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }

        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
