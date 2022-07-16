//
//  RegistrationCompletedViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 15/01/20.
//  Copyright © 2020 MAC Book Air. All rights reserved.
//

import UIKit

class RegistrationCompletedViewController: UIViewController {

    @IBOutlet weak var lblCongratulations: UILabel!
    @IBOutlet weak var lblBiometricId: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    let congratulations = "Congratulations!\nYou have successfully created your Universal Biometic ID with iVALT®"
    let biometric = "To use this further, please enroll this ID in one of our supported 3rd party apps as described in our FAQ accessible through \"info\" button"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

// MARK: - UIBUTTON ACTIONS
extension RegistrationCompletedViewController {
    @IBAction func doneClicked(_ sender: UIButton) {
        if sender.titleLabel?.text == Alert.CANCEL {
            self.navigationController?.popViewController(animated: true)
        } else {
            if let vc = ViewControllerHelper.getViewController(ofType: .HomeViewController) as? HomeViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
