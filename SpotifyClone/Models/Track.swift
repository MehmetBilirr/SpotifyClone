//
//  Track.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 6.01.2023.
//

import Foundation


// MARK: - Track
struct Track: Codable {
    var album: Album?
    let artists: [Artist]
    let discNumber, durationMS: Int
    let externalUrls: ExternalUrls
    let id: String
    let name: String
    let previewURL: String?


    enum CodingKeys: String, CodingKey {
        case album, artists
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case externalUrls = "external_urls"
        case id
        case name
        case previewURL = "preview_url"
    }
}

struct TracksResponse: Codable {
 let items: [Track]
}
