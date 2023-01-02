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
    return webView
  }()
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
  
}
