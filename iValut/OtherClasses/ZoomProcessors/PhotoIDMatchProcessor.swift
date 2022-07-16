//
// Welcome to the annotated FaceTec Device SDK core code for performing secure Photo ID Scans!
//

import UIKit
import Foundation
import FaceTecSDK

// This is an example self-contained class to perform Photo ID Scans with the FaceTec SDK.
// You may choose to further componentize parts of this in your own Apps based on your specific requirements.
class PhotoIDScanProcessor: NSObject, Processor, FaceTecFaceScanProcessorDelegate, FaceTecIDScanProcessorDelegate, URLSessionTaskDelegate {
    var latestNetworkRequest: URLSessionTask!
    var success = false
    var fromViewController: ZoomViewController!
    var faceScanResultCallback: FaceTecFaceScanResultCallback!
    var idScanResultCallback: FaceTecIDScanResultCallback!

    init(sessionToken: String, fromViewController: ZoomViewController) {
        self.fromViewController = fromViewController
        super.init()
        //
        // Part 1:  Starting the FaceTec Session
        //
        // Required parameters:
        // - delegate:
        // - faceScanProcessorDelegate: A class that implements FaceTecFaceScanProcessor, which handles the FaceScan when the User completes a Session.  In this example, "self" implements the class.
        // - sessionToken:  A valid Session Token you just created by calling your API to get a Session Token from the Server SDK.
        //
        let idScanViewController = FaceTec.sdk.createSessionVC(faceScanProcessorDelegate: self, idScanProcessorDelegate: self, sessionToken: sessionToken)
        
        // In your code, you will be presenting from a UIViewController elsewhere. You may choose to augment this class to pass that UIViewController in.
        // In our example code here, to keep the code in this class simple, we will just get the Sample App's UIViewController statically.
        fromViewController.present(idScanViewController, animated: true, completion: nil)
    }
    
    //
    // Part 2: Handling the Result of a FaceScan
    //
    func processSessionWhileFaceTecSDKWaits(sessionResult: FaceTecSessionResult, faceScanResultCallback: FaceTecFaceScanResultCallback) {
        //
        // DEVELOPER NOTE:  These properties are for demonstration purposes only so the Sample App can get information about what is happening in the processor.
        // In the code in your own App, you can pass around signals, flags, intermediates, and results however you would like.
        //
        fromViewController.setLatestSessionResult(sessionResult: sessionResult)
        
        //
        // DEVELOPER NOTE:  A reference to the callback is stored as a class variable so that we can have access to it while performing the Upload and updating progress.
        //
        self.faceScanResultCallback = faceScanResultCallback
        
        //
        // Part 3: Handles early exit scenarios where there is no FaceScan to handle -- i.e. User Cancellation, Timeouts, etc.
        //
        if sessionResult.status != FaceTecSessionStatus.sessionCompletedSuccessfully {
            if latestNetworkRequest != nil {
                latestNetworkRequest.cancel()
            }
            
            faceScanResultCallback.onFaceScanResultCancel()
            return
        }
        
        //
        // Part 4:  Get essential data off the FaceTecSessionResult
        //
        var parameters: [String : Any] = [:]
        parameters["faceScan"] = sessionResult.faceScanBase64
        parameters["auditTrailImage"] = sessionResult.auditTrailCompressedBase64![0]
        parameters["lowQualityAuditTrailImage"] = sessionResult.lowQualityAuditTrailCompressedBase64![0]
        parameters["externalDatabaseRefID"] = "\(Helper.getPREF(UserDefaults.PREF_USERID) ?? "")"
        
        //
        // Part 5:  Make the Networking Call to Your Servers.  Below is just example code, you are free to customize based on how your own API works.
        //
        let request = NSMutableURLRequest(url: NSURL(string: Config.BaseURL + "/enrollment-3d")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
        request.addValue(Config.DeviceKeyIdentifier, forHTTPHeaderField: "X-Device-Key")
        request.addValue(FaceTec.sdk.createFaceTecAPIUserAgentString("\(Helper.getPREF(UserDefaults.PREF_USERID) ?? "")"), forHTTPHeaderField: "User-Agent")
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        latestNetworkRequest = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            //
            // Part 6:  In our Sample, we evaluate a boolean response and treat true as success, false as "User Needs to Retry",
            // and handle all other non-nominal responses by cancelling out.  You may have different paradigms in your own API and are free to customize based on these.
            //
            guard let data = data else {
                // CASE:  UNEXPECTED response from API. Our Sample Code keys of a success boolean on the root of the JSON object --> You define your own API contracts with yourself and may choose to do something different here based on the error.
                faceScanResultCallback.onFaceScanResultCancel()
                return
            }
            
            guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] else {
                // CASE:  UNEXPECTED response from API.  Our Sample Code keys of a success boolean on the root of the JSON object --> You define your own API contracts with yourself and may choose to do something different here based on the error.
                faceScanResultCallback.onFaceScanResultCancel()
                return
            }
            
            //
            // DEVELOPER NOTE:  These properties are for demonstration purposes only so the Sample App can get information about what is happening in the processor.
            // In the code in your own App, you can pass around signals, flags, intermediates, and results however you would like.
            //
            self.fromViewController.setLatestServerResult(responseJSON: responseJSON)
            
            let didSucceed = responseJSON["success"] as? Bool
            
            if didSucceed == true {
                // CASE:  Success! User successfully enrolled.
                
                // Demonstrates dynamically setting the Success Screen Message.
                FaceTecCustomization.setOverrideResultScreenSuccessMessage("Liveness\nConfirmed")
                
                faceScanResultCallback.onFaceScanResultSucceed()
            }
            else if (didSucceed == false) {
                // CASE:  In our Sample code, "success" being present and false means that the User Needs to Retry.
                // Real Users will likely succeed on subsequent attempts after following on-screen guidance.
                // Attackers/Fraudsters will continue to get rejected.
                faceScanResultCallback.onFaceScanResultRetry()
            }
            else {
                // CASE:  UNEXPECTED response from API.  Our Sample Code keys of a success boolean on the root of the JSON object --> You define your own API contracts with yourself and may choose to do something different here based on the error.
                faceScanResultCallback.onFaceScanResultCancel()
            }
        })
        
        //
        // Part 8:  Actually send the request.
        //
        latestNetworkRequest.resume()
        
        //
        // Part 9:  For better UX, update the User if the upload is taking a while.  You are free to customize and enhance this behavior to your liking.
        //
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if self.latestNetworkRequest.state == .completed { return }
            
            let uploadMessage:NSMutableAttributedString = NSMutableAttributedString.init(string: "Still Uploading...")
            faceScanResultCallback.onFaceScanUploadMessageOverride(uploadMessageOverride: uploadMessage)
        }
    }
    
    //
    // Part 10: Handling the Result of a FaceScan
    //
    func processIDScanWhileFaceTecSDKWaits(idScanResult: FaceTecIDScanResult, idScanResultCallback: FaceTecIDScanResultCallback) {
        //
        // DEVELOPER NOTE:  These properties are for demonstration purposes only so the Sample App can get information about what is happening in the processor.
        // In the code in your own App, you can pass around signals, flags, intermediates, and results however you would like.
        //
        fromViewController.setLatestIDScanResult(idScanResult: idScanResult)
        
        //
        // DEVELOPER NOTE:  A reference to the callback is stored as a class variable so that we can have access to it while performing the Upload and updating progress.
        //
        self.idScanResultCallback = idScanResultCallback
        
        //
        // Part 11: Handles early exit scenarios where there is no IDScan to handle -- i.e. User Cancellation, Timeouts, etc.
        //
        if idScanResult.status != FaceTecIDScanStatus.success {
            if latestNetworkRequest != nil {
                latestNetworkRequest.cancel()
            }
            
            idScanResultCallback.onIDScanResultCancel()
            return
        }
        
        // IMPORTANT:  FaceTecSDK.FaceTecIDScanStatus.Success DOES NOT mean the IDScan 3d-2d Matching was Successful.
        // It simply means the User completed the Session and a 3D FaceScan was created. You still need to perform the IDScan 3d-2d Matching on your Servers.

        //
        // minMatchLevel allows Developers to specify a Match Level that they would like to target in order for success to be true in the response.
        // minMatchLevel cannot be set to 0.
        // minMatchLevel setting does not affect underlying Algorithm behavior.
        let minMatchLevel = 3
        
        //
        // Part 12:  Get essential data off the FaceTecSessionResult
        //
        var parameters: [String : Any] = [:]
        parameters["idScan"] = idScanResult.idScanBase64
        if idScanResult.frontImagesCompressedBase64?.isEmpty == false {
            parameters["idScanFrontImage"] = idScanResult.frontImagesCompressedBase64![0]
        }
        if idScanResult.backImagesCompressedBase64?.isEmpty == false {
            parameters["idScanBackImage"] = idScanResult.backImagesCompressedBase64![0]
        }
        parameters["minMatchLevel"] = minMatchLevel
        parameters["externalDatabaseRefID"] = "\(Helper.getPREF(UserDefaults.PREF_USERID) ?? "")"
        
        //
        // Part 13:  Make the Networking Call to Your Servers.  Below is just example code, you are free to customize based on how your own API works.
        //
        let request = NSMutableURLRequest(url: NSURL(string: Config.BaseURL + "/match-3d-2d-idscan")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
        request.addValue(Config.DeviceKeyIdentifier, forHTTPHeaderField: "X-Device-Key")
        request.addValue(FaceTec.sdk.createFaceTecAPIUserAgentString("\(Helper.getPREF(UserDefaults.PREF_USERID) ?? "")"), forHTTPHeaderField: "User-Agent")
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        latestNetworkRequest = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            //
            // Part 14:  In our Sample, we evaluate a boolean response and treat true as success, false as "User Needs to Retry",
            // and handle all other non-nominal responses by cancelling out.  You may have different paradigms in your own API and are free to customize based on these.
            //
            guard let data = data else {
                // CASE:  UNEXPECTED response from API. Our Sample Code keys of a success boolean on the root of the JSON object --> You define your own API contracts with yourself and may choose to do something different here based on the error.
                idScanResultCallback.onIDScanResultCancel()
                return
            }
            
            guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] else {
                // CASE:  UNEXPECTED response from API.  Our Sample Code keys of a success boolean on the root of the JSON object --> You define your own API contracts with yourself and may choose to do something different here based on the error.
                idScanResultCallback.onIDScanResultCancel()
                return
            }
            
            //
            // DEVELOPER NOTE:  These properties are for demonstration purposes only so the Sample App can get information about what is happening in the processor.
            // In the code in your own App, you can pass around signals, flags, intermediates, and results however you would like.
            //
            self.fromViewController.setLatestServerResult(responseJSON: responseJSON)
            
            let didSucceed = responseJSON["success"] as? Bool
            let fullIDStatusEnumInt = responseJSON["fullIDStatusEnumInt"] as! Int
            let digitalIDSpoofStatusEnumInt = responseJSON["digitalIDSpoofStatusEnumInt"] as! Int

            if didSucceed == true {
                // CASE:  Success! User successfully enrolled.
               
                //
                // DEVELOPER NOTE:  These properties are for demonstration purposes only so the Sample App can get information about what is happening in the processor.
                // In the code in your own App, you can pass around signals, flags, intermediates, and results however you would like.
                //
                self.success = true
                
                // Demonstrates dynamically setting the Success Screen Message.
                FaceTecCustomization.setOverrideResultScreenSuccessMessage("Your 3D Face\nMatched Your ID")

                idScanResultCallback.onIDScanResultSucceed()
            }
            else if (didSucceed == false) {
                
                // CASE:  In our Sample code, "success" being present and false means that the User Needs to Retry.
                // Real Users will likely succeed on subsequent attempts after following on-screen guidance.
                // Attackers/Fraudsters will continue to get rejected.
              
                // Handle invalid ID by displaying custom message
                // If we could not determine the ID was Fully Visible and that the ID was a Physical, alter the feedback message to the User.
                if(fullIDStatusEnumInt == 1 || digitalIDSpoofStatusEnumInt == 1) {
                    idScanResultCallback.onIDScanResultRetry(retryMode: .front, unsuccessMessage: "Photo ID\nNot Fully Visible")
                }
                else {
                    idScanResultCallback.onIDScanResultRetry(retryMode: .front)
                }
            }
            else {
                // CASE:  UNEXPECTED response from API.  Our Sample Code keys of a success boolean on the root of the JSON object --> You define your own API contracts with yourself and may choose to do something different here based on the error.
                idScanResultCallback.onIDScanResultCancel()
            }
        })
        
        //
        // Part 15:  Actually send the request.
        //
        latestNetworkRequest.resume()
        
        //
        // Part 17:  For better UX, update the User if the upload is taking a while.  You are free to customize and enhance this behavior to your liking.
        //
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if self.latestNetworkRequest.state == .completed { return }
            
            let uploadMessage:NSMutableAttributedString = NSMutableAttributedString.init(string: "Still Uploading...")
            idScanResultCallback.onIDScanUploadMessageOverride(uploadMessageOverride: uploadMessage)
        }
    }
    
    //
    // URLSessionTaskDelegate function to get progress while performing the upload to update the UX.
    //
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        if idScanResultCallback != nil {
            idScanResultCallback.onIDScanUploadProgress(uploadedPercent: uploadProgress)
        }
        else {
            faceScanResultCallback.onFaceScanUploadProgress(uploadedPercent: uploadProgress)
        }
    }
    
    //
    //  This function gets called after the FaceTec SDK is completely done.  There are no parameters because you have already been passed all data in the processSessionWhileFaceTecSDKWaits function and have already handled all of your own results.
    //
    func onFaceTecSDKCompletelyDone() {
        // In your code, you will handle what to do after the Photo ID Scan is successful here.
        // In our example code here, to keep the code in this class simple, we will call a static method on another class to update the Sample App UI.
        self.fromViewController.onComplete()
    }
    
    func isSuccess() -> Bool {
        return success
    }
}
