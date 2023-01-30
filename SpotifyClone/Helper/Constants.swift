//
//  Constants.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation

struct Constants {

  static let clientID = YourKeys.clientID
  static let clientSecret = YourKeys.clientSecret
  static let tokenAPIURL = "https://accounts.spotify.com/api/token"
  static let redirectURI = "http://localhost:8888/callback" // Any link works
  static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email%20user-read-currently-playing%20user-read-recently-played"
  static let basicToken = Constants.clientID+":"+Constants.clientSecret

}






