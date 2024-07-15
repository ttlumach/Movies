//
//  YoutubePlayerVC.swift
//  Movies
//
//  Created by Macbook on 15.07.2024.
//

import UIKit
import WebKit

class YouTubePlayerVC: UIViewController {

    var url: URL?
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

