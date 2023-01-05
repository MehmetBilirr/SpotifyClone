//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import Foundation


final class AuthManager {

  static let shared = AuthManager()
  private var refreshingToken = false

  private init(){}

  var signInURL: URL? {
      let base = "https://accounts.spotify.com/authorize"
      let urlString = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
      return URL(string: urlString)
  }

  var isSignedIn:Bool {
    return accessToken != nil
  }

  private var accessToken:String? {
    return UserDefaults.standard.accessToken
  }

  private var refreshToken:String? {
    return UserDefaults.standard.refreshToken
  }

  private var tokenExpirationDate:Date? {
    return UserDefaults.standard.object(forKey: "expires_in") as? Date
  }

  private var shouldRefreshToken:Bool {
    //Refresh Token when 5 minutes left.
    guard let tokenExpirationDate = tokenExpirationDate else {
        return false
    }
    let currentDate = Date()
    let fiveMinutes: TimeInterval = 300
    return currentDate.addingTimeInterval(fiveMinutes) >= tokenExpirationDate
  }

  func exchageCodeForToken(code:String,completion:@escaping ((Bool)->Void)){

    var components = URLComponents()
    components.queryItems = [
        URLQueryItem(name: "grant_type", value: "authorization_code"),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
    ]

    let task = URLSession.shared.dataTask(with: createRequest(apiURL: Constants.tokenAPIURL, method: .post,components: components)!) { [weak self] data, _, err in
        guard let data = data else {
            completion(false)
          print(AppError.unknownError.errorDescription)
            return
        }
        do {
          let json = try JSONDecoder().decode(AuthResponse.self, from: data)
          self?.cacheToken(result: json)
          print(json)

            completion(true)
        } catch {
          print(AppError.errorDecoding.errorDescription)
            completion(false)
        }
    }
    task.resume()
  }

  private var onRefreshBlocks = [((String) -> Void)]()
  public func withValidToken(completion: @escaping ((String) -> Void)) {
      guard !refreshingToken else {
          onRefreshBlocks.append(completion)
          return
      }
      if shouldRefreshToken {
          refreshAccesTokenIfNeccessary { [weak self] success in
              if success {
                  if let token = self?.accessToken {
                      completion(token)
                  }
              }
          }
      } else if let token = accessToken {
          completion(token)

      }
  }

  func refreshAccessToken(completion:@escaping(Bool)-> Void){
    guard shouldRefreshToken else {
      completion(true)
      return
    }
    guard let refreshToken = refreshToken else {return}

    var components = URLComponents()
    components.queryItems = [
        URLQueryItem(name: "grant_type", value: "refresh_token"),
        URLQueryItem(name: "refresh_token", value: refreshToken)
    ]

    let task = URLSession.shared.dataTask(with: createRequest(apiURL: Constants.tokenAPIURL, method: .post, components: components)!) { [weak self] data, _, error in
      guard let data = data else {
          completion(false)
        print(AppError.unknownError.errorDescription)
          return
      }

      do {
        let json = try JSONDecoder().decode(AuthResponse.self, from: data)
        self?.cacheToken(result: json)
        print(json)

          completion(true)
      } catch {
        print(AppError.errorDecoding.errorDescription)
          completion(false)
      }
  }
  task.resume()
  }

  public func refreshAccesTokenIfNeccessary(completion: ((Bool) -> Void)?) {
      guard !refreshingToken else { return }
      guard shouldRefreshToken else {
          completion?(true)
          return
      }
      guard let refreshToken = self.refreshToken else { return }
      refreshingToken = true
      var components = URLComponents()
      components.queryItems = [
          URLQueryItem(name: "grant_type", value: "refresh_token"),
          URLQueryItem(name: "refresh_token", value: refreshToken)
      ]



    let task = URLSession.shared.dataTask(with: createRequest(apiURL: Constants.tokenAPIURL, method: .post, components: components)!) {  data, _, err in
      self.refreshingToken = false
      guard let data = data else {
          completion?(false)
          return
      }
      do {
          let result = try JSONDecoder().decode(AuthResponse.self, from: data)
          self.onRefreshBlocks.forEach( { $0(result.access_token)})
          self.onRefreshBlocks.removeAll()
          self.cacheToken(result: result)
          print(result)
          completion?(true)
      } catch {
          print(err?.localizedDescription)
          completion?(false)
      }

    }
    task.resume()




  }

  private func cacheToken(result:AuthResponse){
    guard let refreshToken = refreshToken else {
      return
    }
    UserDefaults.standard.refreshToken = refreshToken
    UserDefaults.standard.accessToken = result.access_token
    UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expires_in")

  }



  private func createRequest (apiURL: String, method: Method,components:URLComponents) -> URLRequest? {

    guard let url = URL(string: apiURL) else { return nil
      print(AppError.invalidUrl.errorDescription)
    }

    var request = URLRequest(url: url)

    request.httpMethod = method.rawValue

    let data = Constants.basicToken.data(using: .utf8)

    guard let base64String  = data?.base64EncodedString() else {
      print(AppError.randomError("Failed to get base64"))
      return nil
    }

    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("Basic " + base64String, forHTTPHeaderField: "Authorization")
    request.httpBody = components.query?.data(using: .utf8)

     return request
    
 }


  
}




