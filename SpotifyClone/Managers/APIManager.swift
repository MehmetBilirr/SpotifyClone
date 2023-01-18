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


  func getCurrentUserProfile(completion:@escaping(Result<UserProfile,Error>)-> Void){

    request(route: .getCurrentUserProfile, method: .get, completion: completion)
  
  }

  func getReleases(completion:@escaping(Result<NewReleasesResponse,Error>)->Void){

    request(route: .getNewReleases, method: .get, completion: completion)
  }

  func getFeaturedPlaylists(completion:@escaping(Result<CategoryPlaylistsResponse,Error>)->Void){
    request(route: .getFeaturedPlaylists, method: .get, completion: completion)
  }

  private func getRecommendedGenres(completion:@escaping(Result<RecommendedGenresResponse,Error>)->Void) {
    request(route: .getRecommendedGenres, method: .get, completion: completion)
  }


  func getRecommendations(completion:@escaping(Result<TopTracksResponse,Error>)->Void) {

    getRecommendedGenres { result in
      switch result {

      case .success(let model):

        let genres = model.genres
        var seeds = Set<String>()
        while seeds.count < 5 {
            if let random = genres.randomElement() {
                seeds.insert(random)
            }
        }
        self.request(route: .getRecommendations(seeds), method: .get, completion: completion)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  func getAlbumDetails(albumID:String,completion:@escaping(Result<AlbumDetailsResponse,Error>)->Void){

    request(route: .getAlbumDetails(albumID), method: .get, completion: completion)
  }

  func getPlaylistDetails(playlistId:String,completion:@escaping(Result<PlaylistDetailsResponse,Error>)->Void){

    request(route: .getPlaylistDetails(playlistId), method: .get, completion: completion)

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

  func getAllCategories(completion:@escaping(Result<CategoriesResponse,Error>)->Void){
    request(route: .getAllCategories, method: .get, completion: completion)
  }

  func getCategoryPlaylists(categoryId:String,completion:@escaping(Result<CategoryPlaylistsResponse,Error>)->Void){
    request(route: .getCategoryPlaylists(categoryId), method: .get, completion: completion)
  }

  func search(query:String,completion:@escaping(Result<SearchResultResponse,Error>)->Void){
    request(route: .search(query), method: .get, completion: completion)
  }

  func getArtistTopTracks(id:String,completion:@escaping(Result<TopTracksResponse,Error>)->Void){
    request(route: .getArtistTopTracks(id), method: .get, completion: completion)
  }

  func getArtistAlbums(id:String,completion:@escaping(Result<AlbumResponse,Error>)->Void) {
    request(route: .getArtistAlbums(id), method: .get, completion: completion)
  }
//  func getArtistAlbum(query:String){
//
//    createRequest(route: .getArtistAlbums(query), method: .get) { request in
//      URLSession.shared.dataTask(with: request) { data, response, error in
//        if let data = data {
//
//            let responseString = String(data:data, encoding: .utf8) ?? "Could not stringify our data"
//            print("The response is :\n \(responseString)")
//
//
//        }
//
//      }.resume()
//    }
//
//  }

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

  private func handleResponse<T:Codable>(result:Result<Data,Error>?,completion: (Result<T,Error>) -> Void){


      guard let result = result else {
          completion(.failure(AppError.unknownError))

          return
      }

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


  private func createRequest (route: Route, method: Method,completion:@escaping(URLRequest)->Void) {
    AuthManager.shared.withValidToken { token in
      let urlString = Route.baseUrl + route.description

      guard let url = urlString.asURL else {return print(AppError.invalidUrl.localizedDescription)}
      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      request.timeoutInterval = 30
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      completion(request)
    }

 }



}
