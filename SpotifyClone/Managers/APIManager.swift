//
//  APIManager.swift.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 5.01.2023.
//

import Foundation


final class APIManager {
  static let shared = APIManager()

  private init() { }

  // MARK: TabBar Requests

  func getTrack(id:String,completion:@escaping(Result<Track,Error>)-> Void){

    request(route:.getTrack(id) , method: .get, completion: completion)

  }


  // MARK: ProfileView Requests

  func getCurrentUserProfile(completion:@escaping(Result<UserProfile,Error>)-> Void){

    request(route: .getCurrentUserProfile, method: .get, completion: completion)

  }


  // MARK: HomeView Requests

  func getReleases(completion:@escaping(Result<NewReleasesResponse,Error>)->Void){

    request(route: .getNewReleases, method: .get, completion: completion)
  }

  func getFeaturedPlaylists(completion:@escaping(Result<CategoryPlaylistsResponse,Error>)->Void){
    request(route: .getFeaturedPlaylists, method: .get, completion: completion)
  }

  func getUserPlaylist(completion:@escaping(Result<PlaylistResponse,Error>)->Void){

    request(route: .getUserPlaylists, method: .get, completion: completion)
  }

  func getUserRecentlyPlayed(completion:@escaping(Result<PlaylistTracksResponse,Error>)->Void){
    request(route: .getUserRecentlyPlayed, method: .get, completion: completion)
  }


  func getUserSavedAlbums(completion:@escaping(Result<SavedAlbumsResponse,Error>)->Void) {
    request(route: .getUserSavedAlbums, method: .get, completion: completion)
  }



  // MARK: ContentDetailView Requests

  func getAlbumDetails(albumID:String,completion:@escaping(Result<AlbumDetailsResponse,Error>)->Void){

    request(route: .getAlbumDetails(albumID), method: .get, completion: completion)
  }

  func getPlaylistDetails(playlistId:String,completion:@escaping(Result<PlaylistDetailsResponse,Error>)->Void){

    request(route: .getPlaylistDetails(playlistId), method: .get, completion: completion)

  }

  // MARK: LibraryView Requests

  func getUserSavedTracks(completion:@escaping(Result<SavedTracksResponse,Error>)->Void) {
    request(route: .getUserSavedTracks, method: .get, completion: completion)
  }


  // MARK: SearchView Requests

  func getAllCategories(completion:@escaping(Result<CategoriesResponse,Error>)->Void){
    request(route: .getAllCategories, method: .get, completion: completion)
  }

  func getCategoryPlaylists(categoryId:String,completion:@escaping(Result<CategoryPlaylistsResponse,Error>)->Void){
    request(route: .getCategoryPlaylists(categoryId), method: .get, completion: completion)
  }

  func search(query:String,completion:@escaping(Result<SearchResultResponse,Error>)->Void){
    request(route: .search(query), method: .get, completion: completion)
  }
  

  // MARK: ArtistView Requests
  func getArtistTopTracks(id:String,completion:@escaping(Result<TopTracksResponse,Error>)->Void){
    request(route: .getArtistTopTracks(id), method: .get, completion: completion)
  }

  func getArtistAlbums(id:String,completion:@escaping(Result<AlbumResponse,Error>)->Void) {
    request(route: .getArtistAlbums(id), method: .get, completion: completion)
  }


  func getTrack(){

    createRequest(route: .getUserSavedAlbums, method: .get) { request in
      URLSession.shared.dataTask(with: request) { data, response, error in

        if let data = data {
          let responseString = String(data:data, encoding: .utf8) ?? "Could not stringify our data"
          print("The response is :\n \(responseString)")
        }else if let error = error {
          print("The error is : \(error.localizedDescription)")
        }

      }.resume()
    }

    }



  /// <#Description#>
  /// - Parameters:
  ///   - route: <#route description#>
  ///   - method: <#method description#>
  ///   - completion: <#completion description#>
  private func request<T:Codable>(route:Route,method:Method, completion: @escaping(Result<T,Error>) -> Void ) {

    createRequest(route: route, method: method) { request in
      URLSession.shared.dataTask(with: request) { data, response, error in

        var result: Result<Data,Error>?
        if let data = data {
          result = .success(data)
        }else if let error = error {
          result = .failure(error)
          print("The error is : \(error.localizedDescription)")
        }


        DispatchQueue.main.async {

          // TODO decode our result and send back to the user
          self.handleResponse(result: result, completion: completion)


        }
      }.resume()
    }

  }

  /// <#Description#>
  /// - Parameters:
  ///   - result: <#result description#>
  ///   - completion: <#completion description#>
  private func handleResponse<T:Codable>(result:Result<Data,Error>?,completion: (Result<T,Error>) -> Void){
    guard let result = result else {
      completion(.failure(AppError.unknownError))
      return}
    
    switch result {

    case .success(let data):

      let decoder = JSONDecoder()
      guard let response = try? decoder.decode(T.self, from: data) else {
        completion(.failure(AppError.errorDecoding))
        return
      }
      completion(.success(response))
    case .failure(let error):
      completion(.failure(error))
    }


  }


  /// Method is for SPOTIFY WEB API.
  /// - Parameters:
  ///   - route: Base Url for Spotify Api.
  ///   - method: method description
  ///   - completion: completion description
  private func createRequest (route: Route, method: Method,completion:@escaping(URLRequest)->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      guard let accessToken = (UserDefaults.standard.string(forKey: "access_token")) else {return}
      let urlString = Route.baseUrl + route.description
      guard let url = urlString.asURL else {return print(AppError.invalidUrl.localizedDescription)}
      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      request.timeoutInterval = 30
      request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
      completion(request)
    }


  }



}
