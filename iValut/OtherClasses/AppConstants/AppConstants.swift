//
//  AppConstants.swift
//  Doelse
//
//  Created by Apple on 18/12/17.
//  Copyright © 2017 ATPL. All rights reserved.
//

import UIKit

struct CurrentDevice {
    static let isiPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    static let iPhone4S = isiPhone && UIScreen.main.bounds.size.height == 480
    static let iPhone5  = isiPhone && UIScreen.main.bounds.size.height == 568.0
    static let iPhone6  = isiPhone && UIScreen.main.bounds.size.height == 667.0
    static let iPhone6P = isiPhone && UIScreen.main.bounds.size.height == 736.0
    static let iPhoneX  = isiPhone && UIScreen.main.bounds.size.height == 812.0
    static let iPhoneXR = isiPhone && UIScreen.main.bounds.size.height == 896.0
    
    static let isiPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    static let iPadMini = isiPad && UIScreen.main.bounds.size.height <= 1024
}

// App constants
struct AppConstants {
    static let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
    static let PORTRAIT_SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    static let PORTRAIT_SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let CURRENT_IOS_VERSION = UIDevice.current.systemVersion
    static let errSomethingWentWrong  = NSError(domain: Alert.ALERT_SOMETHING_WENT_WRONG, code: 0, userInfo: nil)
}

enum FaceID {
    static let appleId = "appleId"
}

struct iValtFonts {
    static let FONT_MONTSERRAT_MEDIUM_12 = UIFont.init(name: "Montserrat-Medium", size: 12)
    static let FONT_MONTSERRAT_MEDIUM_16 = UIFont.init(name: "Montserrat-Medium", size: 16)
    static let FONT_MONTSERRAT_MEDIUM_102 = UIFont.init(name: "Montserrat-Medium", size: 102)
    static let FONT_MONTSERRAT_REGULAR_14 = UIFont.init(name: "Montserrat-Regular", size: 14)
    static let FONT_MONTSERRAT_REGULAR_16 = UIFont.init(name: "Montserrat-Regular", size: 16)
    static let FONT_MONTSERRAT_REGULAR_18 = UIFont.init(name: "Montserrat-Regular", size: 18)
    static let FONT_MONTSERRAT_SEMIBOLD_12 = UIFont.init(name: "Montserrat-SemiBold", size: 12)
    static let FONT_MONTSERRAT_SEMIBOLD_16 = UIFont.init(name: "Montserrat-SemiBold", size: 16)
    static let FONT_MONTSERRAT_SEMIBOLD_18 = UIFont.init(name: "Montserrat-SemiBold", size: 18)
}

// CELLIDS
struct CellIds {
    static let LinkedAppsCell               = "LinkedAppsCell"
    static let ViewLogsCell                 = "ViewLogsCell"
}

// Color Constants
struct iVaultColors {
    static let LIGHT_BLUE_COLOR             = UIColor.init(hex: "5e8fb5")
}

// Font Constants
struct iVaultFonts {
    static let FONT_LATO_REGULAR_10         = UIFont.init(name: "Lato-Regular", size: 10)
}

struct Strings {
    static let ADD_MORE_URL                 = "0"
    static let WORDPRESS                    = "wordpress"
    static let LOGIN                        = "login"
    static let GLOBAL                       = "global"
    static let HOME                         = "HOME"
    static let LINKED                       = "LINKED"
    static let SELF_TEST                    = "SELF TEST"
    static let PROFILE                      = "PROFILE"
    static let ABOUT                        = "About"
    static let FAQ                          = "FAQ"
    static let SUCCESS                      = "success"
    static let CONTACT_US                   = "Contact Us"
    static let REGISTER                     = "Click here to register"
    static let PHONE_REGISTERED             = "You are registered with iVALT® using phone number"
    static let SUCCESSFULLY_REGISTERED      = "Successfully registered with iVALT®"
    static let FACE_AUTHENTICATION          = "Click here for Face Authentication"
}

struct Alert {
    static let OK                           = "Ok"
    static let ERROR                        = "Error"
    static let FAILED                       = "Authentication failed"
    static let SUCCESS                      = "Success"
    static let ALERT                        = "Alert"
    static let THANK_YOU                    = "Thank You"
    static let CONFIRMATION                 = "Confirmation"
    static let PROPOSAL_SENT                = "Proposal Sent"
    static let CANCEL                       = "Cancel"
    static let DONE                         = "Done"
    static let INFO                         = "Info"
    static let LIVENESS                     = "Liveness Check"
    static let AUTHENTICATE                 = "Authenticate"
    static let ALERT_SOMETHING_WENT_WRONG   = "Whoops, something went wrong. Please refresh and try again."
}
