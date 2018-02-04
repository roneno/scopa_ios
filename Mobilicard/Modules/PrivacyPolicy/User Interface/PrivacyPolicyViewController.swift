//
//  PrivacyPolicyViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        webView.delegate? = self
        webView.loadRequest(URLRequest(url: URL(string: "https://vend.mobilicard.com/legal/privacy.html")!))

    }
    @IBAction func dismisssViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension PrivacyPolicyViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

