//
//  SearchResultResponse.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 14.01.2023.
//

import Foundation


struct SearchResultResponse: Codable {
    let albums: AlbumResponse
    let artists: ArtistResponse
    let playlists: PlaylistResponse
    let tracks: TracksResponse
}
