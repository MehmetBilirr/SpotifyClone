//
//  PlaylistDetailsResponse.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 11.01.2023.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String?
    let externalUrls: ExternalUrls
    let id: String
    let images: [APIImage]
    let name: String
    let owner: Owner
    let tracks: PlaylistTracksResponse


    enum CodingKeys: String, CodingKey {
        case description
        case externalUrls = "external_urls"
        case id, images, name, owner
        case tracks
    }

}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]

}

struct PlaylistItem: Codable {
    let track: Track
}



