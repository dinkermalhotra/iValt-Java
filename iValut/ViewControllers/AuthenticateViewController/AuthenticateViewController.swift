//
//  AuthenticateViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 07/10/19.
//  Copyright © 2019 MAC Book Air. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticateViewController: UIViewController {

    var customTab = CustomTabViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCustomTabView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupCustomTabView() {
        if CurrentDevice.iPhoneX || CurrentDevice.iPhoneXR {
            customTab.view.frame = CGRect.init(x: 0, y: AppConstants.PORTRAIT_SCREEN_HEIGHT - 83, width: AppConstants.PORTRAIT_SCREEN_WIDTH, height: 49)
        } else {
            customTab.view.frame = CGRect.init(x: 0, y: AppConstants.PORTRAIT_SCREEN_HEIGHT - 49, width: AppConstants.PORTRAIT_SCREEN_WIDTH, height: 49)
        }
        customTab.currentScreen = Strings.SELF_TEST
        self.addChild(customTab)
        self.view.addSubview(customTab.view)
    }
    
    func faceAuthentication() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        Helper.showOKAlert(onVC: self ?? AuthenticateViewController(), title: Alert.SUCCESS, message: AlertMessages.SELF_TEST)
                    } else {
                        Helper.showOKAlert(onVC: self ?? AuthenticateViewController(), title: Alert.FAILED, message: error?.localizedDescription ?? AlertMessages.PASSCODE_NOT_ALLOWED)
                    }
                }
            }
        } else {
            Helper.showOKAlert(onVC: self, title: Alert.FAILED, message: AlertMessages.FACE_ID_NOT_CONFIGURED)
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension AuthenticateViewController {
    @IBAction func selfTestClicked(_ sender: UIButton) {
        faceAuthentication()
    }
    
    @IBAction func demoTestSite(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .DemoSiteViewController) as? DemoSiteViewController {
            let navigationController = UINavigationController.init(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnViewLogsClicked(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .StatusViewController) as? StatusViewController {
            let navigationController = UINavigationController.init(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
