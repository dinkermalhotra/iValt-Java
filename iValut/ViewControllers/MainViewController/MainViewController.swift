//
//  MainViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 17/03/20.
//  Copyright © 2020 MAC Book Air. All rights reserved.
//

import UIKit
import Foundation
import LocalAuthentication

class MainViewController: UIViewController {

    @IBOutlet weak var imgApple: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Helper.setPREF(FaceID.appleId, key: UserDefaults.PREF_FACE_ID)
        faceAuthentication()
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
                        Helper.setBoolPREF(true, key: UserDefaults.PREF_IS_FACE_SCANNED)
                        if let vc = ViewControllerHelper.getViewController(ofType: .ZoomViewController) as? ZoomViewController {
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        Helper.showOKAlert(onVC: self ?? MainViewController(), title: Alert.FAILED, message: error?.localizedDescription ?? AlertMessages.PASSCODE_NOT_ALLOWED)
                    }
                }
            }
        } else {
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.ERROR, message: AlertMessages.FACE_ID_NOT_CONFIGURED, btnOkTitle: "Settings", btnCancelTitle: "Cancel", onOk: {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            })
        }
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        Helper.setPREF(FaceID.appleId, key: UserDefaults.PREF_FACE_ID)
        faceAuthentication()
    }
    
    @IBAction func appleFaceId(_ sender: UIButton) {
        imgApple.image = #imageLiteral(resourceName: "ic_radio_check")
        
        Helper.setPREF(FaceID.appleId, key: UserDefaults.PREF_FACE_ID)
    }
    
    @IBAction func menuClicked(_ sender: UIButton) {
        Helper.showOKAlert(onVC: self, title: Alert.INFO, message: AlertMessages.INFO)
    }
}
