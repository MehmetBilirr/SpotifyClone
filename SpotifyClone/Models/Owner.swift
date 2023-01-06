//
//  Owner.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 6.01.2023.
//

import Foundation

struct Owner: Codable {
    let displayName: String
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case href, id, type, uri
    }
}
