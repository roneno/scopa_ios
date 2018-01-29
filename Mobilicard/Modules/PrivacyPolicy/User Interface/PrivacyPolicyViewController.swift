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
        webView.loadRequest(URLRequest(url: URL(string: "https://vend.mobilicard.com/legal/privacy.html")!))
    }
    @IBAction func dismisssViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
