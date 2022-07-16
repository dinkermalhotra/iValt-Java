//
//  HomeViewController.swift
//  iValt
//
//  Created by Dinker Malhotra on 02/10/19.
//  Copyright © 2019 MAC Book Air. All rights reserved.
//

import UIKit
import Foundation
import LocalAuthentication
import UserNotifications
import CoreLocation
import PusherSwift

protocol HomeViewControllerDelegate {
    func fetchData(_ channel: String, _ key: String)
}
var homeViewControllerDelegate: HomeViewControllerDelegate?

class HomeViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var customTab = CustomTabViewController()
    var channel = ""
    var key = ""
    var isFromNotification = false
    var userLatitude = "0.0"
    var userLongitude = "0.0"
    var address = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()

        homeViewControllerDelegate = self
        setupCustomTabView()
        detectNotification()
        getUserLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            if self.isFromNotification {
                self.faceAuthentication()
            }
        })
    }
    
    func setupCustomTabView() {
        if CurrentDevice.iPhoneX || CurrentDevice.iPhoneXR {
            customTab.view.frame = CGRect.init(x: 0, y: AppConstants.PORTRAIT_SCREEN_HEIGHT - 83, width: AppConstants.PORTRAIT_SCREEN_WIDTH, height: 49)
        } else {
            customTab.view.frame = CGRect.init(x: 0, y: AppConstants.PORTRAIT_SCREEN_HEIGHT - 49, width: AppConstants.PORTRAIT_SCREEN_WIDTH, height: 49)
        }
        customTab.currentScreen = Strings.HOME
        self.addChild(customTab)
        self.view.addSubview(customTab.view)
    }
    
    func detectNotification() {
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.NOTIFICATION_OFF)
            } else if settings.authorizationStatus == .denied {
                Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.NOTIFICATION_OFF)
            } else if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.registerForNotifications(UIApplication.shared)
                    }
                }
            }
        })
    }
    
    func getUserLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//                            if self?.type == Strings.GLOBAL {
//                                self?.globalUser(true)
//                            } else {
//                                if self?.type == Strings.WORDPRESS && self?.requestFor == Strings.LOGIN {
//                                    self?.loginUser()
//                                } else {
//                                    self?.uploadRegister()
//                                }
//                            }
                        })
                    } else {
                        //self?.globalUser(false)
                        Helper.showOKAlert(onVC: self ?? HomeViewController(), title: Alert.ERROR, message: error?.localizedDescription ?? "")
                    }
                }
            }
        } else {
            //self.globalUser(false)
            Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: AlertMessages.FACE_ID_NOT_CONFIGURED)
        }
    }
}

// MARK: - LOCATION DELEGATE
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.userLatitude = "\(userLocation.coordinate.latitude)"
        self.userLongitude = "\(userLocation.coordinate.longitude)"
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if let error = error {
                print("error in reverseGeocode")
                self.address = error.localizedDescription
            }
            else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    self.address = "\(placemark.thoroughfare ?? "") \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
                } else {
                    self.address = "No Matching Addresses Found"
                }
            }
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension HomeViewController {    
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

// MARK: - PUSHER DELEGATE
extension HomeViewController: PusherDelegate {
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        print("old: \(old.stringValue()) -> new: \(new.stringValue())")
    }
    
    func subscribedToChannel(name: String) {
        print("Subscribed to \(name)")
    }
    
    func debugLog(message: String) {
        print(message)
    }
    
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        print(name)
    }
    
    func receivedError(error: PusherError) {
        if let code = error.code {
            print("Received error: (\(code)) \(error.message)")
        } else {
            print("Received error: \(error.message)")
        }
    }
}

// MARK: - CUSTOM DELEGATE
extension HomeViewController: HomeViewControllerDelegate {
    func fetchData(_ channel: String, _ key: String) {
        self.isFromNotification = true
        self.channel = channel
        self.key = key
        
        let options = PusherClientOptions(authMethod: .inline(secret: "05fde12df61bddf5d01a"))
        let pusher = Pusher(key: "9a0b59f3df41f7d6aac5", options: options)
        pusher.delegate = self
        pusher.connect()
        
        let myChannel = pusher.subscribe(channel)
        
        let _ = myChannel.bind(eventName: key, callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let message = data["message"] as? String {
                    print(message)
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            if self.isFromNotification {
                self.faceAuthentication()
            }
        })
    }
}

//// MARK: - API CALL
//extension HomeViewController {
//    func uploadRegister() {
//        if WSManager.isConnectedToInternet() {
//            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_MOBILE: mobile as AnyObject,
//                                               WSRequestParams.WS_REQS_PARAM_TOKEN: token as AnyObject,
//                                               WSRequestParams.WS_REQS_PARAM_DOMAIN: website as AnyObject]
//            print(params)
//            WSManager.wsCallRegisterConfirmation(params, completion: { (isSuccess, message) in
//                if isSuccess {
//
//                }
//            })
//        } else {
//
//        }
//    }
//
//    func loginUser() {
//        if WSManager.isConnectedToInternet() {
//            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_MOBILE: mobile as AnyObject,
//                                                WSRequestParams.WS_REQS_PARAM_TOKEN: token as AnyObject,
//                                                WSRequestParams.WS_REQS_PARAM_DOMAIN: website as AnyObject]
//            WSManager.wsCallLoginConfirmation(params, completion: { (isSuccess, message) in
//                if isSuccess {
//
//                }
//            })
//        } else {
//
//        }
//    }
//
//    func globalUser(_ value: Bool) {
//        if WSManager.isConnectedToInternet() {
//            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_MOBILE: Helper.getPREF(UserDefaults.PREF_MOBILE_NUMBER) as AnyObject,
//                                               WSResponseParams.WS_RESP_PARAM_STATUS: value as AnyObject,
//                                               WSRequestParams.WS_REQS_PARAM_LATITUDE: self.userLatitude as AnyObject,
//                                               WSRequestParams.WS_REQS_PARAM_LONGITUDE: self.userLongitude as AnyObject,
//                                               WSRequestParams.WS_REQS_PARAM_ADDRESS: self.address as AnyObject]
//            WSManager.wsCallGlobalAuthentication(params, completion: { (isSuccess, message) in
//                print(isSuccess)
//                self.isFromNotification = false
//            })
//        } else {
//
//        }
//    }
//}
