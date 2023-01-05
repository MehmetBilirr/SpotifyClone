//
//  TableModel.swift.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import Foundation

struct Section {
    let sectionName: String
    let rowsInSection: [Row]
}
struct Row {
    let title: String
    let handler: () -> Void
}
