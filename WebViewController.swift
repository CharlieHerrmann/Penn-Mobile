//
//  WebViewController.swift
//  PennMobile
//
//  Created by Charlie Herrmann on 9/23/19.
//  Copyright © 2019 Charlie Herrmann. All rights reserved.
//

import UIKit
import WebKit
//view controller of the webview
class WebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var links: String = ""
    
    override func viewDidLoad() {
        //loads website based on link proivided by tableview controller
        super.viewDidLoad()
        let url = URL (string: links)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    
}
