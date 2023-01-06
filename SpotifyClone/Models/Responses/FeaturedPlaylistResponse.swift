//
//  FeaturedPlaylistResponse.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 6.01.2023.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}
struct PlaylistResponse: Codable {
    let items: [Playlist]
}
