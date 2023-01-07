//
//  UserProfile.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

struct UserProfile: Codable {
    let country, displayName, email: String
    let explicitContent: String
    let externalUrls: String
    let followers: Int
    let href: String
    let id: String
    let images: [APIImage]
    let product, type, uri: String

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case followers, href, id, images, product, type, uri
    }
}

// MARK: - ExplicitContent
struct ExplicitContent: Codable {
    let filterEnabled, filterLocked: Bool

    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String
}

// MARK: - Followers
struct Followers: Codable {
    let total: Int
    
}



