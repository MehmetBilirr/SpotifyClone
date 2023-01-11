//
//  SpotifyModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 10.01.2023.
//

import Foundation

struct SpotifyModel {

  struct NewReleaseModel {
      let name: String
      let image: String
      let numberOfTracks: Int
      let artistName: String
  }

  struct PlaylistModel {

      let name: String
      let image: String
      let creatorName: String
  }

  struct TrackModel {
      let name: String
      let artistName: String
      let image: String?
  }
  
}
