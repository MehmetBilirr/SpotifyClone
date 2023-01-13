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
  case getRecommendedGenres
  case getRecommendations(Set<String>)
  case getAlbumDetails(String)
  case getPlaylistDetails(String)
  case getUserPlaylists
  case getUserRecentlyPlayed
  case getUserSavedAlbums
  case getAllCategories
  case getCategoryPlaylists(String)

  
  var description:String {
    switch self {
    case .getCurrentUserProfile:
      return "/me"
    case .getNewReleases:
      return "/browse/new-releases?limit=50"
    case .getFeaturedPlaylists:
      return "/browse/featured-playlists?country=TR"
    case .getRecommendedGenres:
      return "/recommendations/available-genre-seeds"
    case .getRecommendations(let genres):
      let seeds = genres.joined(separator: ",")
      return "/recommendations?limit=40&seed_genres=\(seeds)"
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
    case .getAllCategories:
      return "/browse/categories"
    case.getCategoryPlaylists(let categoryID):
      return "/browse/categories/\(categoryID)/playlists"
    }




  }

}
