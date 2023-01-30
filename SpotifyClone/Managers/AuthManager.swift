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

  //SignInURL property for sign in with spotify user and get permissions.
  var signInURL: URL? {
      let base = "https://accounts.spotify.com/authorize"
      let scope = Constants.scopes
      let urlString = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
      return URL(string: urlString)
  }

  var isSignedIn:Bool {
    return accessToken != nil
  }

  private var accessToken: String? {
      return UserDefaults.standard.string(forKey: "access_token")
  }
  private var refreshToken: String? {
      return UserDefaults.standard.string(forKey: "refresh_token")
  }
  private var tokenExpirationDate: Date? {
      return UserDefaults.standard.object(forKey: "expires_in") as? Date
  }

  // Propoerty return true 5 minute before expiration date.
  private var shouldRefreshToken:Bool {
    //Refresh Token when 5 minutes left.
    guard let tokenExpirationDate = tokenExpirationDate else {
        return false
    }
    let currentDate = Date()
    let fiveMinutes: TimeInterval = 360
    return currentDate.addingTimeInterval(fiveMinutes) >= tokenExpirationDate
  }


  /// https://developer.spotify.com/documentation/general/guides/authorization/code-flow/ ->Request for Access Token.
  /// - Parameters:
  ///   - code: After  authorization code returned from the previous request.
  ///   - completion: If data is decoded, saveToken method is triggered.
  func exchageCodeForToken(code:String,completion:@escaping ((Bool)->Void)){
    var components = URLComponents()

    //Request Body Parameter's of request access token.
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
          self?.saveToken(result: json)
          print(json)
            completion(true)
        } catch {
          print(AppError.errorDecoding.errorDescription)
            completion(false)
        }
    }
    task.resume()
  }




  /// After 1 hour get the refresh token, it has to be refresh. shouldRefreshToken is true 5 minute before expiration date.
  /// - Parameter completion: If data decoded, saveToken is triggered.
   func refreshAccesTokenIfNeccessary(completion: ((Bool) -> Void)?) {
      guard !refreshingToken else { return }
      guard shouldRefreshToken else {
          completion?(true)
          return
      }
      guard let refreshToken = self.refreshToken else { return }
      refreshingToken = true

     //Body Parameters of Refresh Access token.
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

          self.saveToken(result: result)
          print(result)
          completion?(true)
      } catch {
          print(err?.localizedDescription)
          completion?(false)
      }

    }
    task.resume()

  }

  //Access Token, Refresh Token and Expires date is saved in database.
  private func saveToken(result:AuthResponse){
    UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
    if let refreshToken = result.refresh_token {
        UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
    }
    UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expires_in")

  }

  /// https://developer.spotify.com/documentation/general/guides/authorization/code-flow/ -> Request for  Request User Authorization,Request Access Token,Request a refreshed Access Token
  /// - Parameters:
  ///   - apiURL: https://accounts.spotify.com/api/token -> TOKEN API URL
  ///   - method: POST,GET
  ///   - components: Each request's has Request Body Paramater.
  /// - Returns: URLRequest
  private func createRequest (apiURL: String, method: Method,components:URLComponents) -> URLRequest? {

    guard let url = URL(string: apiURL) else { return nil
      print(AppError.invalidUrl.errorDescription)
    }

    var request = URLRequest(url: url)

    request.httpMethod = method.rawValue

    // data: <base64 encoded client_id:client_secret>
    let data = Constants.basicToken.data(using: .utf8)

    guard let base64String  = data?.base64EncodedString() else {
      print(AppError.randomError("Failed to get base64"))
      return nil
    }

    //Header parameters are same of Request a refreshed Access Token,Request Access Token

    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("Basic " + base64String, forHTTPHeaderField: "Authorization")

    // Request body parameter
    request.httpBody = components.query?.data(using: .utf8)

     return request
    
 }


  /// Sign Out method all values are deleted from database.
  /// - Parameter completion: true or false
  func signOut(completion: (Bool) -> Void) {
      UserDefaults.standard.setValue(nil, forKey: "access_token")
      UserDefaults.standard.setValue(nil, forKey: "refresh_token")
      UserDefaults.standard.setValue(nil, forKey: "expires_in")
      completion(true)
  }
  
}




