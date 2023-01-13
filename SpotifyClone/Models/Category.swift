//
//  Category.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 12.01.2023.
//

import Foundation


//MARK: - Category
struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}



// MARK: - Categories
struct Categories: Codable {
    let items: [Category]

}
