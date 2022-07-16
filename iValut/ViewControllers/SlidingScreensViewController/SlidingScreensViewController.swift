//
//  SlidingScreensViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 04/01/20.
//  Copyright © 2020 MAC Book Air. All rights reserved.
//

import UIKit

class SlidingScreensViewController: UIViewController {
    
    @IBOutlet weak var lblNotCreated: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        if Helper.getPREF(UserDefaults.PREF_USERID) != nil {
            lblNotCreated.isHidden = true
            if Helper.getBoolPREF(UserDefaults.PREF_IS_FACE_SCANNED) {
                if let vc = ViewControllerHelper.getViewController(ofType: .HomeViewController) as? HomeViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if let vc = ViewControllerHelper.getViewController(ofType: .MainViewController) as? MainViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - ACTIONS
extension SlidingScreensViewController {
    @IBAction func startClicked(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.registerForNotifications(UIApplication.shared)
        }
        
        if let vc = ViewControllerHelper.getViewController(ofType: .UserRegistrationViewController) as? UserRegistrationViewController {
            self.navigationController?.pushViewController(vc, animated: true)
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
