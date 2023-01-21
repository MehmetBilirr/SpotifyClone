//
//  UserProfile.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let external_urls: ExternalUrls
    let id: String
    let product: String
    let images: [APIImage]
}


// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String
}




