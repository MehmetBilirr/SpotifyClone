//
//  SavedTracksResponse.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 20.01.2023.
//

import Foundation

struct SavedTracksResponse: Codable {
    let items: [SavedTrack]

}

struct SavedTrack: Codable {
    let addedAt: String
    let track: Track
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case track
    }
}
