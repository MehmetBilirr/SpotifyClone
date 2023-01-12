//
//  SavedAlbumsResponse.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 12.01.2023.
//

import Foundation

struct SavedAlbumsResponse: Codable {

    let items: [SavedAlbum]

}

struct SavedAlbum: Codable {
    let addedAt: String
    let album: Album

    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case album
    }
}
