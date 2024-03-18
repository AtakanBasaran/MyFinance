//
//  NewsWebViewController.swift
//  MyFinance
//
//  Created by Atakan Başaran on 28.11.2023.
//

import UIKit
import WebKit

class NewsWebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var webUrl = ""
    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: webUrl) {
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    


}
