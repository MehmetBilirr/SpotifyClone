//
//  Notification + Extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 21.01.2023.
//

import Foundation

extension NSNotification.Name {

    static let trackNotification = NSNotification.Name("trackID")
    static let didTapPlayButton = NSNotification.Name("tappedPlayButton")
    static let didTapPlayerView = NSNotification.Name("tappedPlayerView")
   static let didTapVCPlayButton = NSNotification.Name("didTapVCPlayButton")
}
