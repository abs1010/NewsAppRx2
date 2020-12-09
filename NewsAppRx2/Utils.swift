//
//  Utils.swift
//  NewsAppRx2
//
//  Created by Alan Silva on 07/12/20.
//

import Foundation
import UIKit
import Lottie

public class UtilLoader: NSObject {
    
    private static let animationName: String = "loading"
    
    static var messageFrame = UIView()
    
    static func getLoadingIcon(width screenWidth: CGFloat, height screenHeight: CGFloat) -> UIView {
        if let animation = Animation.named(animationName, bundle: Bundle.main, subdirectory: CoreConstants.Keys.Animation.path.rawValue) {
            let animationLoading = AnimationView(animation: animation)
            animationLoading.loopMode = .loop
            animationLoading.play()
            animationLoading.contentMode = .scaleToFill
            animationLoading.frame = CGRect(x: (screenWidth / 2) - 150, y:( screenHeight / 2) - 180, width: 300, height: 300)
            return animationLoading
        } else {
            let imageLoading = UIImageView(image: UIImage(named: "devoluo"))
            imageLoading.frame = CGRect(x: (screenWidth / 2) - 35, y:( screenHeight / 2) - 55, width: 70, height: 70)
            return imageLoading
        }
    }
    
    public static func progressBarDisplayer(msg: String, _ indicator: Bool) {
        //var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        
        messageFrame.removeFromSuperview()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        messageFrame = UIView(frame: CGRect(x: 0, y: 0 , width: screenWidth, height: screenHeight))
        messageFrame.layer.cornerRadius = 0
        messageFrame.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 32/255, alpha: 0.9)
        
        let loadingIcon = getLoadingIcon(width: screenWidth, height: screenHeight)
        loadingIcon.contentMode = .scaleAspectFit
        messageFrame.addSubview(loadingIcon)
        
        strLabel = UILabel(frame: CGRect(x: (screenWidth / 2) - 100, y: ( screenHeight / 2) + 15, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textAlignment = .center
        strLabel.textColor = UIColor.white
        messageFrame.addSubview(strLabel)
        
        let mainView = UIApplication.shared.topViewController?.view
        mainView?.addSubview(messageFrame)
    }
    
    public static func biggerProgressBarDisplayer(msg1:String, msg2: String, _ indicator:Bool ){
        //var activityIndicator = UIActivityIndicatorView()
        messageFrame.removeFromSuperview()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        messageFrame = UIView(frame: CGRect(x: 0, y: 0 , width: screenWidth, height: screenHeight))
        messageFrame.layer.cornerRadius = 0
        messageFrame.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 32/255, alpha: 0.9)
        
        let loadingIcon = getLoadingIcon(width: screenWidth, height: screenHeight)
        messageFrame.addSubview(loadingIcon)
        
        var strLabel = UILabel()
        strLabel = UILabel(frame: CGRect(x: (screenWidth / 2) - 150, y: ( screenHeight / 2) + 15, width: 300, height: 50))
        strLabel.text = msg1
        strLabel.textAlignment = .center
        strLabel.textColor = UIColor.white
        strLabel.font = UIFont(name: "GothamRounded-Medium", size: 14)
        messageFrame.addSubview(strLabel)
        
        var strLabel2 = UILabel()
        strLabel2 = UILabel(frame: CGRect(x: (screenWidth / 2) - 150, y: ( screenHeight / 2) - 50, width: 300, height: 50))
        strLabel2.text = msg2
        strLabel2.textAlignment = .center
        strLabel2.textColor = UIColor.white
        strLabel2.font = UIFont(name: "GothamRounded-Medium", size: 14)
        messageFrame.addSubview(strLabel2)
        
        let mainView = UIApplication.shared.topViewController?.view
        mainView?.addSubview(messageFrame)
        //messageFrame.removeFromSuperview()
    }
    
    public static func removeProgressBarDisplay() {
        messageFrame.removeFromSuperview()
    }
}

extension UIApplication {
    /// Current presented view controller
    public var topViewController: UIViewController? {
        guard var topController: UIViewController = keyWindow?.rootViewController else {return nil}
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    /// Home bar height
    public var homeBarHeight: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottomPadding = window?.safeAreaInsets.bottom {
                return bottomPadding
            }
        }
        return 0.0
    }
}

public class CoreConstants {
    public struct URL {}
    public struct Enuns {}
    public struct Strings {}
    public struct Keys {}
    public struct StyleSheet {}
    
    public struct Localization {
        public static let timeZone: TimeZone? = TimeZone(abbreviation: "GMT-3")
        public static let locale: Locale? = Locale.init(identifier: "pt_BR")
    }
    
    public struct HideFeatures {
        public static let rating: Bool = true
        public static let payWithPoints: Bool = true
    }
}

extension CoreConstants.Keys {
    enum Animation: String {
        case path = "Animations"
    }
}

class MessageUtil {
    static var messageFrame = UIView()
    static var mainView = UIView()
    static var gameTimer: Timer?

    static func showErrorMessage(mainView : UIView? = nil, msg:String)  {
        guard let view = MessageUtil.topMostController().view else {return}
        var message: String? = msg
    
        // confere pra ver se a string contém caracteres especiais em UTF-8
        if msg.contains("Ã§Ã£") || msg.contains("Ã£") || msg.contains("Ã¡") {
            let messageChar = msg.cString(using: String.Encoding.isoLatin1)
            
            if let messageChar = messageChar {
                message = String(cString: messageChar)
            }
        }
        
        if gameTimer != nil {
            runTimedCode()
        }
        
        messageFrame = CustomMessageView(message: message, type: .error, didTap: {
            self.runTimedCode()
        })
        
        showView(mainView: view, viewToAdd: messageFrame)
        self.mainView = view
        gameTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc
    static func runTimedCode() {
        gameTimer?.invalidate()
        removeView(mainView: mainView, viewToAdd: messageFrame)
    }
    
    static func showSuccessMessage(mainView: UIView? = nil, msg:String)  {
        guard let view = mainView ?? MessageUtil.topMostController().view else {return}
        
        if gameTimer != nil {
            runTimedCode()
        }
        
        messageFrame = CustomMessageView(message: msg, type: .success, didTap: {
            self.runTimedCode()
        })
        
        showView(mainView: view, viewToAdd: messageFrame)
        self.mainView = view
        
        gameTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    static func showView(mainView: UIView, viewToAdd:UIView){
        viewToAdd.alpha = 0
        mainView.willRemoveSubview(viewToAdd)
        mainView.addSubview(viewToAdd)
        fadeIn(view: viewToAdd)
    }
    
    static func removeView(mainView: UIView, viewToAdd:UIView){
        mainView.willRemoveSubview(viewToAdd)
        fadeOut(view: viewToAdd)
    }
    
    static func fadeIn(view: UIView, withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    static func fadeOut(view: UIView, withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0.0
        })
    }
}



extension MessageUtil {
    
    static func showAlert(title: String, message: String){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        }))
        
        let topVC = topMostController()
        topVC.present(refreshAlert, animated: true, completion: nil)
    }
    
    static func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}

extension CustomMessageView {
    enum CustomMessageViewType {
        case error, success
    }
}

class CustomMessageView: UIView {
    
    private var messageLabel: UILabel!
    private var didTap: (() -> Void)?
    private var message: String?
    private var type: CustomMessageViewType?
    private var topConstant: CGFloat = {
        return UIDevice.current.hasNotch ? 60 : 36
    }()
    
    public convenience init(message: String?, type: CustomMessageViewType, didTap: (() -> Void)?) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        self.message = message
        self.type = type
        self.didTap = didTap
        commonInit()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        setupViews()
        setupConstraints()
        setupActions()
        layoutIfNeeded()
        layoutSubviews()
    }
    
    private func setupViews() {
        switch type {
        case .error?:
            backgroundColor = UIColor(named: "FF4748")
        case .success?:
            backgroundColor = UIColor(red: 134/255, green: 201/255, blue: 50/255, alpha: 1.0)
        default:
            break
        }
        
        messageLabel = UILabel()
        messageLabel.font = UIFont(name: "GothamRounded-Book", size: 15)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: topConstant),
            messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAction)))
    }
    
    @objc private func didTapAction() {
        didTap?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame.size.height = messageLabel.frame.height + topConstant + 16
    }

}


///==========

extension UIDevice {
    public enum DeviceModel {
        case iPhone5_iPhone5S_iPhone5C
        case iPhone6_iPhone6S_iPhone7_iPhone8
        case iPhone6Plus_iPhone6SPlus_iPhone7Plus_iPhone8Plus
        case iPhoneX_iPhoneXS
        case iPhoneXR
        case iPhoneXSMax
    }
    
    public var modelByResolution: DeviceModel? {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return .iPhone5_iPhone5S_iPhone5C
            case 1334:
                return .iPhone6_iPhone6S_iPhone7_iPhone8
            case 1920, 2208:
                return .iPhone6Plus_iPhone6SPlus_iPhone7Plus_iPhone8Plus
            case 2436:
                return .iPhoneX_iPhoneXS
            case 2688:
                return .iPhoneXR
            case 1792:
                return .iPhoneXSMax
            default:
                return nil
            }
        }
        return nil
    }
    
    public var hasNotch: Bool {
        if self.modelByResolution == .iPhoneX_iPhoneXS
            || self.modelByResolution == .iPhoneXR
            || self.modelByResolution == .iPhoneXSMax {
            return true
        }
        return false
    }
    
    public static var identifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    public static let modelName: String = {
        func mapToDevice(identifier: String) -> String {
            #if os(iOS)
            switch identifier {
                case "iPod5,1":                                 return "iPod touch (5th generation)"
                case "iPod7,1":                                 return "iPod touch (6th generation)"
                case "iPod9,1":                                 return "iPod touch (7th generation)"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
                case "iPhone11,8":                              return "iPhone XR"
                case "iPhone12,1":                              return "iPhone 11"
                case "iPhone12,3":                              return "iPhone 11 Pro"
                case "iPhone12,5":                              return "iPhone 11 Pro Max"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
                case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
                case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
                case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
                case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
                case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
                case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
                case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
                case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
                case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
                case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
                case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
                case "AppleTV5,3":                              return "Apple TV"
                case "AppleTV6,2":                              return "Apple TV 4K"
                case "AudioAccessory1,1":                       return "HomePod"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}

