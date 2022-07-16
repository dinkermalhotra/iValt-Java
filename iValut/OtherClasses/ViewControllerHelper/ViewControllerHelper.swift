//
//  ViewControllerHelper.swift
//  Doelse
//
//  Created by Apple on 16/12/17.
//  Copyright © 2017 ATPL. All rights reserved.
//

struct ViewControllerIdentifiers {
    
    static let SlidingScreensViewController             = "SlidingScreensViewController"
    static let MainViewController                       = "MainViewController"
    static let UserRegistrationViewController           = "UserRegistrationViewController"
    static let OtpViewController                        = "OtpViewController"
    static let HomeViewController                       = "HomeViewController"
    static let AboutViewController                      = "AboutViewController"
    static let LinkedAppsViewController                 = "LinkedAppsViewController"
    static let StatusViewController                     = "StatusViewController"
    static let AuthenticateViewController               = "AuthenticateViewController"
    static let RegistrationCompletedViewController      = "RegistrationCompletedViewController"
    static let AboutUsViewController                    = "AboutUsViewController"
    static let ContactUsViewController                  = "ContactUsViewController"
    static let DemoSiteViewController                   = "DemoSiteViewController"
    static let ZoomViewController                       = "ZoomViewController"
}

import UIKit

enum ViewControllerType {
    case SlidingScreensViewController
    case MainViewController
    case UserRegistrationViewController
    case OtpViewController
    case HomeViewController
    case AboutViewController
    case LinkedAppsViewController
    case StatusViewController
    case AuthenticateViewController
    case RegistrationCompletedViewController
    case AboutUsViewController
    case ContactUsViewController
    case DemoSiteViewController
    case ZoomViewController
}

class ViewControllerHelper: NSObject {
    
    // This is used to retirve view controller and intents to reutilize the common code.
    
    class func getViewController(ofType viewControllerType: ViewControllerType) -> UIViewController {
        var viewController: UIViewController?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if viewControllerType == .SlidingScreensViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SlidingScreensViewController) as! SlidingScreensViewController
        } else if viewControllerType == .MainViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.MainViewController) as! MainViewController
        } else if viewControllerType == .UserRegistrationViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.UserRegistrationViewController) as! UserRegistrationViewController
        } else if viewControllerType == .OtpViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.OtpViewController) as! OtpViewController
        } else if viewControllerType == .HomeViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.HomeViewController) as! HomeViewController
        } else if viewControllerType == .AboutViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.AboutViewController) as! AboutViewController
        } else if viewControllerType == .LinkedAppsViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.LinkedAppsViewController) as! LinkedAppsViewController
        } else if viewControllerType == .StatusViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.StatusViewController) as! StatusViewController
        } else if viewControllerType == .AuthenticateViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.AuthenticateViewController) as! AuthenticateViewController
        } else if viewControllerType == .RegistrationCompletedViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.RegistrationCompletedViewController) as! RegistrationCompletedViewController
        } else if viewControllerType == .AboutUsViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.AboutUsViewController) as! AboutUsViewController
        } else if viewControllerType == .ContactUsViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ContactUsViewController) as! ContactUsViewController
        } else if viewControllerType == .DemoSiteViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.DemoSiteViewController) as! DemoSiteViewController
        } else if viewControllerType == .ZoomViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.ZoomViewController) as! ZoomViewController
        }
        else {
            print("Unknown view controller type")
        }
        
        if let vc = viewController {
            return vc
        } else {
            return UIViewController()
        }
    }
}
