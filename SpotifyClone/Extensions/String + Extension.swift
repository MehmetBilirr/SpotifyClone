//
//  String + Extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import Foundation


extension String {

  var asURL:URL? {
    return URL(string: self)
  }
}
