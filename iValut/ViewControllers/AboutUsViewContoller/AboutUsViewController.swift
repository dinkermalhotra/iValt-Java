//
//  AboutUsViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 17/01/20.
//  Copyright © 2020 MAC Book Air. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    func setupNavigationBar() {
        self.title = "About Us"
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backCkicled(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @IBAction func backCkicled(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
