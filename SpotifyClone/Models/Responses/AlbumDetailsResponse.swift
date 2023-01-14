//
//  AlbumDetailsResponse.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let id: String
    let images: [APIImage]
    let label, name: String
    let releaseDate: String
    let totalTracks: Int
    let tracks: TracksResponse

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case id, images, label, name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case tracks
    }
}


