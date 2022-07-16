//
//  LinkedAppsViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 07/10/19.
//  Copyright © 2019 MAC Book Air. All rights reserved.
//

import UIKit

class LinkedAppsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var jsonResponse = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        fetchWebsites()
    }
    
    func setupNavigationBar() {
        self.title = "Linked Apps"
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backCkicled(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @IBAction func backCkicled(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITABLEVIEW METHODS
extension LinkedAppsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.LinkedAppsCell, for: indexPath) as! LinkedAppsCell
        cell.lblUrl.text = jsonResponse[indexPath.row] as? String
        return cell
    }
}

// MARK: - API CALL
extension LinkedAppsViewController {
    func fetchWebsites() {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_MOBILE: Helper.getPREF(UserDefaults.PREF_MOBILE) as AnyObject]
            WSManager.wsCallWebsiteList(params, completion: { (isSuccess, resonse) in
                self.jsonResponse = resonse
                self.tableView.reloadData()
            })
        } else {
            
        }
    }
}
