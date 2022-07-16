//
//  StatusViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 07/10/19.
//  Copyright © 2019 MAC Book Air. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var jsonResponse = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        fetchLogs()
    }
    
    func setupNavigationBar() {
        self.title = "View Logs"
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backCkicled(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @IBAction func backCkicled(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIBUTTON ACTIONS
extension StatusViewController {
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITABLEVIEW METHODS
extension StatusViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.ViewLogsCell, for: indexPath) as! ViewLogsCell
        let dict = jsonResponse[indexPath.row]
        
        let dateString = dict[WSResponseParams.WS_RESP_PARAM_CREATED_AT] as? String
        cell.lblDate.text = Helper.convertDate(dateString ?? "")
        cell.lblDetail.text = dict[WSResponseParams.WS_RESP_PARAM_DETAIL] as? String
        
        return cell
    }
}

// MARK: - API CALL
extension StatusViewController {
    func fetchLogs() {
        if WSManager.isConnectedToInternet() {
            WSManager.wsCallLogsList(completion: { (isSuccess, response) in
                self.jsonResponse = response
                self.tableView.reloadData()
            })
        } else {
            
        }
    }
}
