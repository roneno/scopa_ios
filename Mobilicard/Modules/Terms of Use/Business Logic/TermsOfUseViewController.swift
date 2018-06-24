//
//  TermsOfUseViewController.swift
//  Mobilicard
//
//  Created by Vsevolod Ban on 6/24/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

class TermsOfUseViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        webView.delegate? = self
        webView.loadRequest(URLRequest(url: URL(string: "https://vend.mobilicard.com/legal/terms_of_service.html")!))
    }
}

extension TermsOfUseViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
