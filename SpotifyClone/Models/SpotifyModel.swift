//
//  SpotifyModel.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 10.01.2023.
//

import Foundation

struct SpotifyModel {

  struct AlbumModel {
      let name: String
      let image: String
      let numberOfTracks: Int
      let artistName: String

  }

  struct PlaylistModel {
      let name: String
      let image: String
      let creatorName: String
      let description:String



 
  }

  struct TrackModel {
      let name: String
      let artistName: String
      let image: String?

  }
  
}
