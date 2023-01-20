//
//  Route.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import Foundation


enum Route {

  static let baseUrl = "https://api.spotify.com/v1"

  case getCurrentUserProfile
  case getNewReleases
  case getFeaturedPlaylists
  case getAlbumDetails(String)
  case getPlaylistDetails(String)
  case getUserPlaylists
  case getUserRecentlyPlayed
  case getUserSavedAlbums
  case getUserSavedTracks
  case getAllCategories
  case getCategoryPlaylists(String)
  case search(String)
  case getArtistTopTracks(String)
  case getArtistAlbums(String)

  
  var description:String {
    switch self {
    case .getCurrentUserProfile:
      return "/me"
    case .getNewReleases:
      return "/browse/new-releases?limit=50"
    case .getFeaturedPlaylists:
      return "/browse/featured-playlists?country=TR"
    case.getAlbumDetails(let albumID):
      return "/albums/\(albumID)"
    case.getPlaylistDetails(let playlistID):
      return "/playlists/\(playlistID)"
    case .getUserPlaylists:
      return "/me/playlists"
    case.getUserRecentlyPlayed:
      return "/me/player/recently-played?limit=50"
    case .getUserSavedAlbums:
      return "/me/albums?limit=20"
    case .getUserSavedTracks:
      return "/me/tracks?limit=50"
    case .getAllCategories:
      return "/browse/categories"
    case.getCategoryPlaylists(let categoryID):
      return "/browse/categories/\(categoryID)/playlists"
    case.search(let string):
      let query = string.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
      return "/search?limit=10&type=album,artist,playlist,track&q=\(query)"
    case .getArtistTopTracks(let artistID):
      return "/artists/\(artistID)/top-tracks?market=US"
    case .getArtistAlbums(let artistID):
      return "/artists/\(artistID)/albums?limit=10"
    }

  }

}
