//
//  FAQViewController.swift
//  ConditionController
//
//  Created by Vincenzo on 27/04/2017.
//  Copyright © 2017 vincenzoOlivito. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pdf = Bundle.main.url(forResource: "F.A.Q.", withExtension: "pdf")
        {
            webView.loadRequest(URLRequest(url: pdf))
        }
    }
}
