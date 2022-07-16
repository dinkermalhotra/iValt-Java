//
//  CustomTabViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 19/11/19.
//  Copyright © 2019 MAC Book Air. All rights reserved.
//

import UIKit

class CustomTabViewController: UIViewController {

    @IBOutlet weak var tabView: UIView!
    
    var currentScreen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// MARK: - UIBUTTON ACTIONS
extension CustomTabViewController {
    @IBAction func homeClicked(_ sender: UIButton) {
        if currentScreen != Strings.HOME {
            for i in 0...self.navigationController!.viewControllers.count {
                if (self.navigationController?.viewControllers[i].isKind(of: HomeViewController.self) == true) {
                    _ = self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! HomeViewController, animated: true)
                    break;
                }
            }
        }
    }
    
    @IBAction func linkedClicked(_ sender: UIButton) {
        if currentScreen != Strings.LINKED {
            if self.navigationController?.viewControllers.contains(where: {
                return $0 is LinkedAppsViewController
            }) ?? true {
                for i in 0...self.navigationController!.viewControllers.count {
                    if (self.navigationController?.viewControllers[i].isKind(of: LinkedAppsViewController.self) == true) {
                        _ = self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! LinkedAppsViewController, animated: true)
                        break;
                    }
                }
            } else {
                if let vc = ViewControllerHelper.getViewController(ofType: .LinkedAppsViewController) as? LinkedAppsViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            }
        }
    }
    
    @IBAction func selfTestClicked(_ sender: UIButton) {
        if currentScreen != Strings.SELF_TEST {
            if self.navigationController?.viewControllers.contains(where: {
                return $0 is AuthenticateViewController
            }) ?? true {
                for i in 0...self.navigationController!.viewControllers.count {
                    if (self.navigationController?.viewControllers[i].isKind(of: AuthenticateViewController.self) == true) {
                        _ = self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! AuthenticateViewController, animated: true)
                        break;
                    }
                }
            } else {
                if let vc = ViewControllerHelper.getViewController(ofType: .AuthenticateViewController) as? AuthenticateViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            }
        }
    }
    
    @IBAction func profileClicked(_ sender: UIButton) {
        if currentScreen != Strings.PROFILE {
            if self.navigationController?.viewControllers.contains(where: {
                return $0 is AboutViewController
            }) ?? true {
                for i in 0...self.navigationController!.viewControllers.count {
                    if (self.navigationController?.viewControllers[i].isKind(of: AboutViewController.self) == true) {
                        _ = self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! AboutViewController, animated: true)
                        break;
                    }
                }
            } else {
                if let vc = ViewControllerHelper.getViewController(ofType: .AboutViewController) as? AboutViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            }
        }
    }
}
