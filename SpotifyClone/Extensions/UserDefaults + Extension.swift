//
//  UserDefaults + Extension.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 3.01.2023.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys:String {
        case accessToken
        case refreshToken
        case expiresIn
    }

    var accessToken:String {
        get {
          string(forKey: UserDefaultsKeys.accessToken.rawValue)!
        }
        set {
          setValue(newValue, forKey: UserDefaultsKeys.accessToken.rawValue)
        }
    }

  var refreshToken:String {

    get {
      string(forKey: UserDefaultsKeys.refreshToken.rawValue)!
    }
    set {
      setValue(newValue, forKey: UserDefaultsKeys.refreshToken.rawValue)
    }
  }

  
}