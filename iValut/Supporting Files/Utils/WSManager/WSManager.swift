//
//  WSManager.swift
//  Doelse
//
//  Created by Apple on 14/02/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import Foundation
import Alamofire

class WSManager {
    
    static let header = ["Content-Type": "application/json"]
    
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    // MARK: LOGIN USER
    class func wsCallLogin(_ requestParams: [String: AnyObject], completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        Alamofire.request(WebService.sendSMS, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                print(responseValue)
                if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String != WSResponseParams.WS_RESP_PARAM_ERROR) {
                    completion(true, "")
                } else {
                    if let responseMessage = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                        completion(false, responseMessage)
                    }
                }
            } else {
                completion(false, "No parameters found")
            }
        })
    }
    
    // MARK: REGISTER USER
    class func wsCallRegister(_ requestParams: [String: AnyObject], completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        Alamofire.request(WebService.register, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                print(responseValue)
                if let status = (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS]) as? Bool {
                    if !status {
                        if let responseMessage = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            completion(false, responseMessage)
                        }
                    } else {
                        if let userId = responseValue[WSResponseParams.WS_RESP_PARAM_ID] as? String {
                            Helper.setPREF(userId, key: UserDefaults.PREF_USERID)
                        }
                        completion(true, "")
                    }
                } else {
                    if let userId = responseValue[WSResponseParams.WS_RESP_PARAM_ID] as? String {
                        Helper.setPREF(userId, key: UserDefaults.PREF_USERID)
                    }
                    completion(true, "")
                }
            } else {
                completion(false, "No parameters found")
            }
        })
    }
    
    // MARK: UPDATE TOKEN
    class func wsCallUpdateToken(_ requestParams: [String: AnyObject]) {
        Alamofire.request(WebService.updateToken, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                print(responseValue)
            }
        })
    }
    
    // MARK: REGISTER FOR FACETECH
    class func wsCallRegisterConfirmation(_ requestParams: [String: AnyObject], completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        Alamofire.request(WebService.registerConfirmation, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                print(responseValue)
                completion(true, "")
            } else {
                completion(false, "")
            }
        })
    }
    
    // MARK: LOGIN FOR FACETECH
    class func wsCallLoginConfirmation(_ requestParams: [String: AnyObject], completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        Alamofire.request(WebService.loginConfirmation, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                print(responseValue)
                completion(true, "")
            } else {
                completion(false, "")
            }
        })
    }
    
    // MARK: LIST OF WEBSITES
    class func wsCallWebsiteList(_ requestParams: [String: AnyObject], completion:@escaping (_ isSuccess: Bool, _ response: NSArray)->()) {
        Alamofire.request(WebService.website, method: .get, parameters: requestParams, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                print(responseValue)
                if let websites = responseValue[WSResponseParams.WS_RESP_PARAM_WEBSITES] as? NSArray {
                    completion(true, websites)
                }
            } else {
                completion(false, [[:]])
            }
        })
    }
    
    // MARK: LIST OF LOGS
    class func wsCallLogsList(completion:@escaping (_ isSuccess: Bool, _ response: [[String: AnyObject]])->()) {
        Alamofire.request("\(WebService.logs)\(Helper.getPREF(UserDefaults.PREF_MOBILE) ?? "")", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                print(responseValue)
                if let websites = responseValue[WSResponseParams.WS_RESP_PARAM_LOGS] as? [[String: AnyObject]] {
                    completion(true, websites)
                }
            } else {
                completion(false, [[:]])
            }
        })
    }
    
    // MARK: GLOBAL AUTHENTICATION
    class func wsCallGlobalAuthentication(_ requestParams: [String: Any], completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        Alamofire.request(WebService.global, method: .get, parameters: requestParams, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                print(responseValue)
                completion(true, "")
            } else {
                completion(false, "")
            }
        })
    }
    
    // MARK: SEND MESSAGE
    class func wsCallSendMessage(_ requestParams: [String: AnyObject], completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        Alamofire.request(WebService.contactUs, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                print(responseValue)
                if responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == Strings.SUCCESS {
                    completion(true, responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String ?? "")
                } else {
                    completion(false, responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String ?? "")
                }
            } else {
                completion(false, "")
            }
        })
    }
    
    // MARK: CHECK ENROLLMENT STATUS
    class func wsCallCheckEnrollment(_ requestParam: [String: AnyObject], completion:@escaping (_ isSuccess: Bool)->()) {
        Alamofire.request(WebService.checkEnrollment, method: .post, parameters: requestParam, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                if let value = responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? Int {
                    completion(NSNumber(value: value).boolValue)
                }
            } else {
                completion(false)
            }
        })
    }
    
    // MARK: SET ENROLLMENT STATUS
    class func wsCallSetEnrollment(_ requestParam: [String: AnyObject], completion:@escaping (_ isSuccess: Bool)->()) {
        Alamofire.request(WebService.setEnrollment, method: .post, parameters: requestParam, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            if let responseValue = responseData.result.value as? [String: AnyObject] {
                if responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String == Strings.SUCCESS.lowercased() {
                    completion(true)
                }
                else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        })
    }
}
