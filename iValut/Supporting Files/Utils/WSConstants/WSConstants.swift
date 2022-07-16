//
//  WSConstants.swift
//  Doelse
//
//  Created by Apple on 05/02/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

struct WebService {
    static let baseUrl                               = "https://mdm.kochar.co:8443/Demo/webresources/API"
    static let privacyPolicy                         = "https://ivalt.com/privacypolicy-eula.html"
    static let FAQS                                  = "http://ivalt.com/faqs-for-iphone.php"
    static let help                                  = "https://www.ivalt.com/help/"
    static let register                              = "\(baseUrl)/registerUser"
    static let sendSMS                               = "\(baseUrl)/get_otp"
    static let registerConfirmation                  = "\(baseUrl)/wp/register/confirmation"
    static let loginConfirmation                     = "\(baseUrl)/wp/confirm-login-auth"
    static let updateToken                           = "\(baseUrl)/updateToken"
    static let website                               = "\(baseUrl)/wp/websites"
    static let logs                                  = "\(baseUrl)/logs/"
    static let global                                = "\(baseUrl)/global/authenticate"
    static let contactUs                             = "\(baseUrl)/contact/support"
    static let checkEnrollment                       = "\(baseUrl)/getEnrollmentStatus"
    static let setEnrollment                         = "\(baseUrl)/setEnrollmentStatus"
    static let globalAuth                            = "https://ivalt.com/web-val"
}

struct WSRequestParams {
    static let WS_REQS_PARAM_COUNTRYCODE             = "cc"
    static let WS_REQS_PARAM_MOBILE                  = "mobile"
    static let WS_REQS_PARAM_MOBILENO                = "mobileno"
    static let WS_REQS_PARAM_EMAIL_ID                = "email_id"
    static let WS_REQS_PARAM_OTP                     = "otp"
    static let WS_REQS_PARAM_COUNTRY_CODE            = "country_code"
    static let WS_REQS_PARAM_DEVICE_ID               = "device_id"
    static let WS_REQS_PARAM_DEVICE_TOKEN            = "device_token"
    static let WS_REQS_PARAM_PLATFORM                = "platform"
    static let WS_REQS_PARAM_TOKEN                   = "token"
    static let WS_REQS_PARAM_DOMAIN                  = "domain"
    static let WS_REQS_PARAM_NAME                    = "name"
    static let WS_REQS_PARAM_LATITUDE                = "latitude"
    static let WS_REQS_PARAM_LONGITUDE               = "longitude"
    static let WS_REQS_PARAM_ADDRESS                 = "address"
}

struct WSResponseParams {
    static let WS_RESP_PARAM_STATUS                  = "status"
    static let WS_RESP_PARAM_SUCCESS                 = "success"
    static let WS_RESP_PARAM_MESSAGE                 = "message"
    static let WS_RESP_PARAM_DATA                    = "data"
    static let WS_RESP_PARAM_DATE                    = "date"
    static let WS_RESP_PARAM_ERROR                   = "error"
    static let WS_RESP_PARAM_ID                      = "id"
    static let WS_RESP_PARAM_WEBSITES                = "websites"
    static let WS_RESP_PARAM_LOGS                    = "logs"
    static let WS_RESP_PARAM_DETAIL                  = "detail"
    static let WS_RESP_PARAM_CREATED_AT              = "created_at"
    static let WS_RESP_PARAM_IS_ENROLLED             = "is_enrolled"
}
