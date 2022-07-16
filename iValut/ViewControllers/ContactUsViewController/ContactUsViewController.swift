//
//  ContactUsViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 17/01/20.
//  Copyright © 2020 MAC Book Air. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = "Contact Us"
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backCkicled(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UIBUTTON ACTIONS
extension ContactUsViewController {
    @IBAction func backCkicled(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendClicked(_ sender: UIButton) {
        let emailRegEx = "[a-zA-Z0-9._-]+@[a-z?-]+\\.+[a-z]+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if txtMessage.text.isEmpty {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.MESSAGE_REQUIRED)
        } else if txtEmail.text?.isEmpty ?? true {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.EMAIL_REQUIRED)
        } else if (emailTest.evaluate(with: self.txtEmail.text?.lowercased()) == false) {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.ENTER_VALID_EMAIL)
        }else {
            actInd.startAnimating()
            actInd.isHidden = false
            sendMessage()
        }
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension ContactUsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtMessage.becomeFirstResponder()
        return true
    }
}

// MARK: API CALL
extension ContactUsViewController {
    func sendMessage() {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_MOBILE: Helper.getPREF(UserDefaults.PREF_MOBILE_NUMBER) as AnyObject,
                                               WSResponseParams.WS_RESP_PARAM_MESSAGE: txtMessage.text as AnyObject]
            WSManager.wsCallSendMessage(params, completion: { (isSuccess, message) in
                self.actInd.stopAnimating()
                if isSuccess {
                    self.txtMessage.text = ""
                    Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: message)
                } else {
                    Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: message)
                }
            })
        } else {
            self.actInd.stopAnimating()
        }
    }
}
