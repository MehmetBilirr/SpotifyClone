//
//  Artist.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 6.01.2023.
//

import Foundation

// MARK: - Artist
struct Artist: Codable {
    let externalUrls: ExternalUrls
    let id, name: String
    let type: String
    let images: [APIImage]?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case  id, name, type,images
    }
}


struct ArtistResponse: Codable {
    let items: [Artist]
}
