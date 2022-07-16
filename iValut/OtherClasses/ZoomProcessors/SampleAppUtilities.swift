import Foundation
import UIKit
import FaceTecSDK
import AVFoundation

class SampleAppUtilities: NSObject, FaceTecCustomAnimationDelegate {
    enum SampleAppVocalGuidanceMode {
        case OFF
        case MINIMAL
        case FULL
    }
    
    var vocalGuidanceOnPlayer: AVAudioPlayer!
    var vocalGuidanceOffPlayer: AVAudioPlayer!
    static var sampleAppVocalGuidanceMode: SampleAppVocalGuidanceMode!
    
    // Reference to app's main view controller
    let sampleAppVC: ZoomViewController!
    
    var currentTheme = "FaceTec Theme"
    var themeTransitionTextTimer: Timer!
    
    init(vc: ZoomViewController) {
        sampleAppVC = vc

        var buttonFont: UIFont?
        if #available(iOS 13.0, *) {
            // For iOS 13+, use the rounded system font for displayed text
            if let roundedDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withDesign(.rounded) {
                if let roundedBoldDescriptor = roundedDescriptor.withSymbolicTraits(.traitBold) {
                    buttonFont = UIFont(descriptor: roundedBoldDescriptor, size: 0)
                }
            }
        }
        
        let defaultCustomization = FaceTecCustomization()
        
        let interfaceButtons: [UIButton] = sampleAppVC.view.findViews(subclassOf: UIButton.self)
        for button in interfaceButtons {
            if button.title(for: .normal) == "VocalGuidance" {
                continue
            }
//            button.setBackgroundColor(defaultCustomization.guidanceCustomization.buttonBackgroundNormalColor, for: .normal)
//            button.setBackgroundColor(defaultCustomization.guidanceCustomization.buttonBackgroundHighlightColor, for: .highlighted)
//            button.setBackgroundColor(defaultCustomization.guidanceCustomization.buttonBackgroundDisabledColor, for: .disabled)
//            button.setTitleColor(defaultCustomization.guidanceCustomization.buttonTextNormalColor, for: .normal)
//            button.setTitleColor(defaultCustomization.guidanceCustomization.buttonTextHighlightColor, for: .highlighted)
//            button.setTitleColor(defaultCustomization.guidanceCustomization.buttonTextDisabledColor, for: .disabled)
            
            if buttonFont != nil {
                button.titleLabel!.font = buttonFont!.withSize(button.titleLabel!.font.pointSize)
            }
        }
    }
    
    func showAuditTrailImages() {
        var auditTrailAndIDScanImages: [UIImage] = []
        let latestFaceTecSessionResult = sampleAppVC.latestSessionResult
        let latestFaceTecIDScanResult = sampleAppVC.latestIDScanResult
        
        // Update audit trail.
        if latestFaceTecSessionResult?.auditTrailCompressedBase64 != nil {
            for compressedBase64EncodedAuditTrailImage in (latestFaceTecSessionResult?.auditTrailCompressedBase64)! {
                let dataDecoded : Data = Data(base64Encoded: compressedBase64EncodedAuditTrailImage, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                auditTrailAndIDScanImages.append(decodedimage!)
            }
        }
        
        if latestFaceTecIDScanResult != nil
            && latestFaceTecIDScanResult?.frontImagesCompressedBase64 != nil
            && (latestFaceTecIDScanResult?.frontImagesCompressedBase64?.count)! > 0
        {
            let dataDecoded : Data = Data(base64Encoded: (latestFaceTecIDScanResult?.frontImagesCompressedBase64?[0])!, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            auditTrailAndIDScanImages.append(decodedimage!)
        }
        
        if auditTrailAndIDScanImages.count == 0 {
            return
        }
        for auditImage in auditTrailAndIDScanImages.reversed() {
            addDismissableImageToInterface(image: auditImage)
        }
    }
    
    @objc func dismissImageView(tap: UITapGestureRecognizer){
        let tappedImage = tap.view!
        tappedImage.removeFromSuperview()
    }
    
    // Place a UIImage onto the main interface in a stack that can be popped by tapping on the image
    func addDismissableImageToInterface(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = UIScreen.main.bounds
        
        // Resize image to better fit device's display
        // Remove this option to view image full screen
        let screenSize = UIScreen.main.bounds
        let ratio = screenSize.width / image.size.width
        let size = (image.size).applying(CGAffineTransform(scaleX: 0.5 * ratio, y: 0.5 * ratio))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = scaledImage
        imageView.contentMode = .center
        
        // Tap on image to dismiss view
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissImageView(tap:)))
        imageView.addGestureRecognizer(tap)
        
        sampleAppVC.view.addSubview(imageView)
    }
    
    func handleThemeSelection(theme: String) {
        currentTheme = theme
        ThemeHelpers.setAppTheme(theme: theme)

        // Set this class as the delegate to handle the FaceTecCustomAnimationDelegate methods. This delegate needs to be applied to the current FaceTecCustomization object before starting a new Session in order to use FaceTecCustomAnimationDelegate methods to provide a new instance of a custom UIView that will be displayed for the method-specified animation.
        if(Config.currentCustomization.customAnimationDelegate == nil) {
            Config.currentCustomization.customAnimationDelegate = self
            FaceTec.sdk.setCustomization(Config.currentCustomization)
        }
    }
    
    func setUpVocalGuidancePlayers() {
        SampleAppUtilities.sampleAppVocalGuidanceMode = .MINIMAL

        guard let vocalGuidanceOnUrl = Bundle.main.url(forResource: "vocal_guidance_on", withExtension: "mp3") else { return }
        guard let vocalGuidanceOffUrl = Bundle.main.url(forResource: "vocal_guidance_off", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            vocalGuidanceOnPlayer = try AVAudioPlayer(contentsOf: vocalGuidanceOnUrl)
            vocalGuidanceOffPlayer = try AVAudioPlayer(contentsOf: vocalGuidanceOffUrl)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}

extension UIButton {
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
}

extension UIView {
    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }

    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }
}
