//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation


final class AuthManager {

  static let shared = AuthManager()

  private init(){}

  var signInURL: URL? {
      let base = "https://accounts.spotify.com/authorize"
      let urlString = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
      return URL(string: urlString)
  }

  var isSignedIn:Bool {
    return false
  }

  private var accessToken:String? {
    return nil
  }

  private var refreshToken:String? {
    return nil
  }

  private var tokenExpirationDate:Date? {
return nil
  }

  private var shouldRefreshToken:Bool {
    return false
  }

  func exchageCodeForToken(code:String,completion:@escaping ((Bool)->Void)){

    var components = URLComponents()
    components.queryItems = [
        URLQueryItem(name: "grant_type", value: "authorization_code"),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
    ]

    let task = URLSession.shared.dataTask(with: createRequest(code: code, apiURL: Constants.tokenAPIURL, method: .post,components: components)!) { [weak self] data, _, err in
        guard let data = data else {
            completion(false)
          print(AppError.unknownError)
            return
        }
        do {
          let json = try JSONDecoder().decode(AuthResponse.self, from: data)
          print("json: \(json)")

            completion(true)
        } catch {
          print(AppError.errorDecoding)
            completion(false)
        }
    }
    task.resume()
  }

  func refreshAccessToken(){

  }

  func cacheToken(){
    
  }



  private func createRequest (code:String,apiURL: String, method: Method,components:URLComponents) -> URLRequest? {

    guard let url = URL(string: apiURL) else { return nil
      print(AppError.invalidUrl)
    }

    var request = URLRequest(url: url)

    request.httpMethod = method.rawValue

    let data = Constants.basicToken.data(using: .utf8)

    guard let base64String  = data?.base64EncodedString() else {
      print(AppError.serverError("Failed to get base64"))
      return nil
    }

    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("Basic " + base64String, forHTTPHeaderField: "Authorization")
    request.httpBody = components.query?.data(using: .utf8)

     return request
    
 }


  
}




