//
//  Helper.swift
//  Doelse
//
//  Created by Apple on 16/12/17.
//  Copyright © 2017 ATPL. All rights reserved.
//

import Foundation
import UIKit

class Helper: NSObject {
    
    //MARK:- set and get preferences for NSString
    /*!
     method getPreferenceValueForKey
     abstract To get the preference value for the key that has been passed
     */
    // NSUserDefaults methods which have been used in entire app.
    
    class func getPREF(_ key: String) -> String? {
        return Foundation.UserDefaults.standard.value(forKey: key) as? String
    }
    
    class func getUserPREF(_ key: String) -> Data? {
        return Foundation.UserDefaults.standard.value(forKey: key as String) as? Data
    }
    /*!
     method setPreferenceValueForKey for int value
     abstract To set the preference value for the key that has been passed
     */
    class func setPREF(_ sValue: String, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for string
     abstract To delete the preference value for the key that has been passed
     */
    class func  delPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Integer
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getIntPREF(_ key: String) -> Int? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? Int
    }
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setIntPREF(_ sValue: Int, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for integer
     abstract To delete the preference value for the key that has been passed
     */
    class func  delIntPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Double
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getDoublePREF(_ key: String) -> Double? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? Double
    }
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setDoublePREF(_ sValue: Double, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Array
    /*!
     method getPreferenceValueForKey for array
     abstract To get the preference value for the key that has been passed
     */
    class func getArrPREF(_ key: String) -> [Int]? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? [Int]
    }
    
    class func getStrArrPREF(_ key: String) -> [String]? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? [String]
    }
    /*!
     method setPreferenceValueForKey for array
     abstract To set the preference value for the key that has been passed
     */
    class func setArrPREF(_ sValue: [Int], key: String) {
        Foundation.UserDefaults.standard.set(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    class func setStrArrPREF(_ sValue: [String], key: String) {
        Foundation.UserDefaults.standard.set(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF
     abstract To delete the preference value for the key that has been passed
     */
    class func  delArrPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Dictionary
    /*!
     method getPreferenceValueForKey for dictionary
     abstract To get the preference value for the key that has been passed
     */
    class func getDicPREF(_ key: String)-> NSDictionary {
        let data = Foundation.UserDefaults.standard.object(forKey: key as String) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: String]
        return object as NSDictionary
    }
    /*!
     method setPreferenceValueForKey for dictionary
     abstract To set the preference value for the key that has been passed
     */
    class func setDicPREF(_ sValue: NSDictionary, key: String) {
        Foundation.UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: sValue), forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Boolean
    /*!
     method getPreferenceValueForKey for boolean
     abstract To get the preference value for the key that has been passed
     */
    class func getBoolPREF(_ key: String) -> Bool {
        return Foundation.UserDefaults.standard.bool(forKey: key as String)
    }
    /*!
     method setBoolPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setBoolPREF(_ sValue: Bool , key: String){
        Foundation.UserDefaults.standard.set(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for boolean
     abstract To delete the preference value for the key that has been passed
     */
    class func  delBoolPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    // MARK: -
    class func showOKAlert(onVC viewController:UIViewController,title:String,message:String) {
        DispatchQueue.main.async {
            let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Alert.OK, style:.default, handler: nil))
            
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                    alert.view.tintColor = UIColor.white
                } else {
                    alert.view.tintColor = UIColor.black
                }
            } else {
                // Fallback on earlier versions
            }
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    class func showOKAlertWithCompletion(onVC viewController: UIViewController, title: String, message: String, btnOkTitle: String, onOk: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: btnOkTitle, style:.default, handler: { (action:UIAlertAction) in
                onOk()
            }))
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                    alert.view.tintColor = UIColor.white
                } else {
                    alert.view.tintColor = UIColor.black
                }
            } else {
                // Fallback on earlier versions
            }
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showOKCancelAlertWithCompletion(onVC viewController: UIViewController, title: String, message: String, btnOkTitle: String, btnCancelTitle: String, onOk: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: btnOkTitle, style:.default, handler: { (action:UIAlertAction) in
                onOk()
            }))
            alert.addAction(UIAlertAction(title: btnCancelTitle, style:.default, handler: { (action:UIAlertAction) in
                
            }))
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                    alert.view.tintColor = UIColor.white
                } else {
                    alert.view.tintColor = UIColor.black
                }
            } else {
                // Fallback on earlier versions
            }
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showTwoButtonsAlertWithCompletion(onVC viewController: UIViewController, title: String, message: String, btnOkTitle: String, btnCancelTitle: String, onOk: @escaping ()->(), onCancel: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: btnOkTitle, style:.default, handler: { (action:UIAlertAction) in
                onOk()
            }))
            alert.addAction(UIAlertAction(title: btnCancelTitle, style:.default, handler: { (action:UIAlertAction) in
                onCancel()
            }))
            alert.addAction(UIAlertAction(title: Alert.CANCEL, style:.default, handler: { (action:UIAlertAction) in
                
            }))
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                    alert.view.tintColor = UIColor.white
                } else {
                    alert.view.tintColor = UIColor.black
                }
            } else {
                // Fallback on earlier versions
            }
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showThreeButtonsAlertWithCompletion(onVC viewController: UIViewController, title: String?, message: String?, btnOneTitle: String, btnTwoTitle: String, btnThreeTitle: String, onBtnOneClick: @escaping ()->(), onBtnTwoClick: @escaping ()->(), onBtnThreeClick: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: btnOneTitle, style:.default, handler: { (action:UIAlertAction) in
                onBtnOneClick()
            }))
            alert.addAction(UIAlertAction(title: btnTwoTitle, style:.default, handler: { (action:UIAlertAction) in
                onBtnTwoClick()
            }))
            alert.addAction(UIAlertAction(title: btnThreeTitle, style:.default, handler: { (action:UIAlertAction) in
                onBtnThreeClick()
            }))
            alert.addAction(UIAlertAction(title: Alert.CANCEL, style:.default, handler: { (action:UIAlertAction) in
                
            }))
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                    alert.view.tintColor = UIColor.white
                } else {
                    alert.view.tintColor = UIColor.black
                }
            } else {
                // Fallback on earlier versions
            }
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func convertDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = .current
        //dateFormatter.timeZone = TimeZone(identifier: "GMT")
        let currentDate = dateFormatter.date(from: dateString)
        
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: currentDate ?? Date())
    }
}
