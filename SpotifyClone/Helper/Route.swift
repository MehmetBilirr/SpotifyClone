//
//  Route.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import Foundation


enum Route {

  static let baseUrl = "https://api.spotify.com/v1"

  case getCurrentUserProfile

  var description:String {
    switch self {
    case .getCurrentUserProfile:
      return "/me"
    }
  }



}
