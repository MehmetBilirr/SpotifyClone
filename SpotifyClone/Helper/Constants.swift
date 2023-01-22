//
//  Constants.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation

struct Constants {

  static let clientID = "c760f60cc5114019b063a48d3058de45"
  static let clientSecret = "0a787b38161b47beb8783e60f308125f"
  static let tokenAPIURL = "https://accounts.spotify.com/api/token"
  static let redirectURI = "http://localhost:8888/callback" // Any link works
  static let scopes : [AuthScope] = AuthScope.allCases
  static let basicToken = Constants.clientID+":"+Constants.clientSecret

  
}

enum AuthScope: String, CaseIterable {

  case userReadPrivate = "user-read-private"
  case userReadEmail = "user-read-email"

  case userLibraryRead = "user-library-read"
  case userLibraryModify = "user-library-modify"

  case userTopRead = "user-top-read"
  case userReadRecentlyPlayed = "user-read-recently-played"
  case userReadCurrentlyPlaying = "user-read-currently-playing"

  case userReadPlaybackPosition = "user-read-playback-position"
  case userReadPlaybackState = "user-read-playback-state"
  case userModifyPlaybackState = "user-modify-playback-state"

  case playlistReadPublic = "playlist-read-public"
  case playlistReadPrivate = "playlist-read-private"
  case playlistReadCollaborative = "playlist-read-collaborative"

  case playlistModifyPublic = "playlist-modify-public"
  case playlistModifyPrivate = "playlist-modify-private"

  case userFollowRead = "user-follow-read"
  case userFollowModify = "user-follow-modify"

  case ugcImageUpload = "ugc-image-upload"
}




