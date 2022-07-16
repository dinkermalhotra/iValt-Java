//
//  OtpViewController.swift
//  iValut
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 MAC Book Air. All rights reserved.
//

import UIKit
import LocalAuthentication

class OtpViewController: UIViewController {

    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var strCode: String?
    var strNumber: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loader.stopAnimating()
        self.loader.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - UIBUTTON ACTIONS
extension OtpViewController {
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_submit(_ sender: UIButton) {
        if(txtOtp.text?.isEmpty ?? true) {
            Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: AlertMessages.ENTER_OTP)
        } else {
            self.loader.startAnimating()
            self.loader.isHidden = false
            userRegistration()
        }
    }
    
    @IBAction func menuClicked(_ sender: UIButton) {
        Helper.showThreeButtonsAlertWithCompletion(onVC: self, title: Alert.INFO, message: "", btnOneTitle: Strings.ABOUT, btnTwoTitle: Strings.FAQ, btnThreeTitle: Strings.CONTACT_US, onBtnOneClick: {
            if let vc = ViewControllerHelper.getViewController(ofType: .AboutUsViewController) as? AboutUsViewController {
                let navigationController = UINavigationController.init(rootViewController: vc)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
        }, onBtnTwoClick: {
            guard let url = URL(string: WebService.FAQS) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }, onBtnThreeClick: {
            if let vc = ViewControllerHelper.getViewController(ofType: .ContactUsViewController) as? ContactUsViewController {
                let navigationController = UINavigationController.init(rootViewController: vc)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
        })
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension OtpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - API CALL
extension OtpViewController {
    func userRegistration() {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_MOBILE: strNumber as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_COUNTRY_CODE: strCode as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_OTP: txtOtp.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_DEVICE_TOKEN: Helper.getPREF(UserDefaults.PREF_MY_DEVICE_TOKEN) as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_PLATFORM: "iOS" as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_EMAIL_ID: Helper.getPREF(UserDefaults.PREF_EMAIL) as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_NAME: Helper.getPREF(UserDefaults.PREF_NAME) as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_DEVICE_ID: UIDevice.current.identifierForVendor?.uuidString as AnyObject]
            WSManager.wsCallRegister(params, completion: { (isSuccess, message) in
                if isSuccess {
                    if let vc = ViewControllerHelper.getViewController(ofType: .MainViewController) as? MainViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: message)
                }
            })
        } else {
            
        }
    }
}
