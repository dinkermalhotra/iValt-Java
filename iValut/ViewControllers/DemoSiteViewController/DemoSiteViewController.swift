//
//  DemoSiteViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 01/06/20.
//  Copyright © 2020 MAC Book Air. All rights reserved.
//

import UIKit
import WebKit

class DemoSiteViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupWebView()
    }
    
    func setupWebView() {
        let webView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: AppConstants.PORTRAIT_SCREEN_WIDTH, height: AppConstants.PORTRAIT_SCREEN_HEIGHT))
        self.view.addSubview(webView)
        self.view.bringSubviewToFront(self.backView)
        
        guard let url = URL(string: WebService.globalAuth) else { return }
        let urlRequest = URLRequest.init(url: url)
        webView.load(urlRequest)
    }
    
    func setupNavigationBar() {
        self.title = "Demo Site"
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backCkicled(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        backView.isHidden = true
    }
    
    @IBAction func backCkicled(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
