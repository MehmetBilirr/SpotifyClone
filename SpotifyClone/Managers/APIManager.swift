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



  private func request<T:Codable>(route:Route,method:Method, completion: @escaping(Result<T,Error>) -> Void ) {

      guard let request = createRequest(route: route, method: method) else {

          completion(.failure(AppError.unknownError))

          return
          }

      URLSession.shared.dataTask(with: request) { data, response, error in

          var result: Result<Data,Error>?
          if let data = data {
              result = .success(data)
              let responseString = String(data:data, encoding: .utf8) ?? "Could not stringify our data"
              print("The response is :\n \(responseString)")


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


  private func createRequest (route: Route, method: Method) -> URLRequest? {

    let urlString = Route.baseUrl + route.description
    guard let url = urlString.asURL else {return nil}
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    AuthManager.shared.withValidToken { token in
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    return request
 }



}
