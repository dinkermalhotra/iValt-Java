//
//  UserRegistrationViewController.swift
//  iValut
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 MAC Book Air. All rights reserved.
//

import UIKit
import CountryPickerView

class UserRegistrationViewController: UIViewController {

    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var cpvMain: CountryPickerView!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    
    var countryCode = ""
    var isSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cpvMain.showCountryCodeInView = false
        cpvMain.countryDetailsLabel.font = iValtFonts.FONT_MONTSERRAT_REGULAR_16
        cpvMain.countryDetailsLabel.textColor = UIColor.white
        self.countryCode = cpvMain.countryDetailsLabel.text ?? ""
        cpvMain.delegate = self
        
        loader.isHidden = true
        lblPrivacyPolicy.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - UIBUTTON ACTION
extension UserRegistrationViewController {
    @objc func btnDoneOfToolBarPressed() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let text = self.lblPrivacyPolicy.text ?? ""
        let range = (text as NSString).range(of: "Terms and Conditions")
        if sender.didTapAttributedTextInLabel(label: self.lblPrivacyPolicy, inRange: range) {
            print("terms")
            guard let url = URL(string: WebService.privacyPolicy) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnPrivacyPressed(_ sender: UIButton) {
        if isSelected {
            sender.setImage(#imageLiteral(resourceName: "ic_uncheck"), for: UIControl.State())
            isSelected = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "ic_check"), for: UIControl.State())
            isSelected = true
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
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        let emailRegEx = "[a-zA-Z0-9._-]+@[a-z?-]+\\.+[a-z]+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if countryCode.isEmpty {
            Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: AlertMessages.ENTER_COUNTRY_CODE)
        }
        else if(txtMobileNumber.text?.count == 0) {
            Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: AlertMessages.ENTER_MOBILE_NUMBER)
        }
        else if !isSelected {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.ACCEPT_PRIVACY)
        }
        else if txtEmail.text?.isEmpty ?? true {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.EMAIL_REQUIRED)
        }
        else if (emailTest.evaluate(with: self.txtEmail.text?.lowercased()) == false) {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.ENTER_VALID_EMAIL)
        }  else {
            loader.startAnimating()
            loader.isHidden = false
            userRegistration(txtMobileNumber.text ?? "", countryCode)
        }
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension UserRegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - COUNTRYPICKER METHODS
extension UserRegistrationViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country.phoneCode)
        self.countryCode = country.phoneCode
    }
}

// MARK: - API CALL
extension UserRegistrationViewController {
    func userRegistration(_ userNumber: String, _ countryCode: String) {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_MOBILENO: userNumber as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_COUNTRYCODE: countryCode as AnyObject]
            WSManager.wsCallLogin(params, completion: { (isSuccess, message) in
                if isSuccess {
                    self.loader.stopAnimating()
                    self.loader.isHidden = true
                    if let vc = ViewControllerHelper.getViewController(ofType: .OtpViewController) as? OtpViewController {
                        vc.strCode = self.countryCode
                        vc.strNumber =  self.txtMobileNumber.text ?? ""
                        Helper.setPREF(self.txtEmail.text ?? "", key: UserDefaults.PREF_EMAIL)
                        Helper.setPREF(userNumber, key: UserDefaults.PREF_MOBILE_NUMBER)
                        Helper.setPREF(self.txtMobileNumber.text ?? "", key: UserDefaults.PREF_MOBILE)
                        Helper.setPREF(self.txtName.text ?? "", key: UserDefaults.PREF_NAME)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    self.loader.stopAnimating()
                    self.loader.isHidden = true
                    Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: message )
                }
            })
        } else {
            
        }
    }
}
