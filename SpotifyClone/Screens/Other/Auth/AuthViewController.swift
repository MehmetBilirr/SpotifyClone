//
//  AuthViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit
import WebKit
final class AuthViewController: UIViewController {

  private lazy var webView : WKWebView = {
    let prefs = WKWebpagePreferences()
    let config = WKWebViewConfiguration()
    config.defaultWebpagePreferences = prefs
    let webView = WKWebView(frame: .zero, configuration: config)
    webView.navigationDelegate = self
    view.addSubview(webView)
    guard let url = AuthManager.shared.signInURL else { return WKWebView()}
    webView.load(URLRequest(url: url))
    return webView
  }()
  var completionHandler: ((Bool) -> (Void))?
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Sign In"
      view.backgroundColor = .black


    }


  override func viewDidLayoutSubviews() {
    webView.frame = view.bounds
  }



}


extension AuthViewController:WKNavigationDelegate {

  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    guard let url = webView.url else { return }
    guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else { return }

    AuthManager.shared.exchageCodeForToken(code: code) { [weak self] bool in
      DispatchQueue.main.async {
        self?.navigationController?.popViewController(animated: true)
        self?.completionHandler?(bool)
      }
    }
    print("codeeeee:\(code)")
  }
}
