//
//  WebViewController.swift
//  PennMobile
//
//  Created by Charlie Herrmann on 9/23/19.
//  Copyright © 2019 Charlie Herrmann. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    
    var links: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL (string: links)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    
}
