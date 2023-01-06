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
    let href: String
    let id, name: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}
