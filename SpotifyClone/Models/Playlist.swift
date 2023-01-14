//
//  Playlists.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 6.01.2023.
//

import Foundation

struct Playlist: Codable {
    let itemDescription: String
    let externalUrls: ExternalUrls
    let id: String
    let images: [APIImage]
    let name: String
    let owner: Owner


    enum CodingKeys: String, CodingKey {
        case itemDescription = "description"
        case externalUrls = "external_urls"
        case id, images, name, owner
    }
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}
