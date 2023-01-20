//
//  Album.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 13.01.2023.
//

import Foundation

struct Album: Codable,Hashable {
  static func == (lhs: Album, rhs: Album) -> Bool {
    return lhs.id == rhs.id
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
    
    let albumType: String
    let id: String
    let images: [APIImage]
    let externalUrls:ExternalUrls
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let artists: [Artist]


  enum CodingKeys: String, CodingKey {
      case albumType = "album_type"
      case totalTracks = "total_tracks"
      case releaseDate = "release_date"
      case externalUrls = "external_urls"
      case id, images, name,artists

  }


}

struct AlbumResponse: Codable {
    let items: [Album]
}

