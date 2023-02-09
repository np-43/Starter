//
//  ViewExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit
import QuartzCore

extension UIView {
    
    enum GradientLocation {
        case topBottom
        case bottomTop
        case leftRight
        case rightLeft
        case topLeftBottomRight
        case topRightBottomLeft
        case BottomLeftTopRight
        case BottomRightTopLeft
        
        var locations:[NSNumber] {
            switch self {
                case .topBottom:
                    return [0.0, 1.0]
                case .bottomTop:
                    return [0.0, 1.0]
                case .leftRight:
                    return [0.0, 1.0]
                case .rightLeft:
                    return [0.0, 1.0]
                default:
                    return [0.0, 0.0]
            }
        }
        
        var position:(startPosition: CGPoint, endPosition: CGPoint) {
            switch self {
                case .topBottom:
                    return (startPosition: CGPoint.init(x: 0, y: 0), endPosition: CGPoint.init(x: 0, y: 1))
                case .bottomTop:
                    return (startPosition: CGPoint.init(x: 0, y: 1), endPosition: CGPoint.init(x: 0, y: 0))
                case .leftRight:
                    return (startPosition: CGPoint.init(x: 0, y: 1), endPosition: CGPoint.init(x: 1, y: 1))
                case .rightLeft:
                    return (startPosition: CGPoint.init(x: 1, y: 1), endPosition: CGPoint.init(x: 0, y: 1))
                case .topLeftBottomRight:
                    return (startPosition: CGPoint.init(x: 0, y: 0), endPosition: CGPoint.init(x: 1, y: 1))
                case .topRightBottomLeft:
                    return (startPosition: CGPoint.init(x: 1, y: 0), endPosition: CGPoint.init(x: 0, y: 1))
                case .BottomLeftTopRight:
                    return (startPosition: CGPoint.init(x: 0, y: 1), endPosition: CGPoint.init(x: 1, y: 0))
                case .BottomRightTopLeft:
                    return (startPosition: CGPoint.init(x: 1, y: 1), endPosition: CGPoint.init(x: 0, y: 0))
            }
        }
        
    }
    
    enum ToastDirection {
        case top
        case bottom
        case center
    }
    
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.applyCornerRadius(radius: newValue)
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return (self.layer.borderColor != nil) ? UIColor.init(cgColor: self.layer.borderColor!) : nil
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    func applyCornerRadius(radius: CGFloat = 8) {
        if radius > 0 {
            self.clipsToBounds = true
        }
        self.layer.cornerRadius = radius
    }
    
    func removeCornerRadius() {
        self.layer.cornerRadius = 0
        self.clipsToBounds = false
    }
    
    func roundView() {
        self.applyCornerRadius(radius: self.bounds.height / 2)
    }
    
    func applyBorder(_ borderWidth: CGFloat = 1, borderColor: UIColor = UIColor.black) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func removeBorder() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func applyShadow(withColor color: UIColor, offSetSize: CGSize = CGSize.zero, opacity: Float = 1, radius: CGFloat = 4) {
        self.clipsToBounds = false
//        self.layer.shadowPath = UIBezierPath(rect: CGRect.init(x: -2, y: -2, width: (self.bounds.width + 20), height: (self.bounds.height + 20))).cgPath
//        self.layer.shadowPath = UIBezierPath.init(rect: self.bounds).cgPath
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offSetSize
        self.layer.masksToBounds = false
    }
    
    func applyShadowWithCornerRadius(_ cornerRadius: CGFloat = 8, color: UIColor, offSetSize: CGSize = CGSize.zero, opacity: Float = 1, radius: CGFloat = 8) {
        self.layer.cornerRadius = cornerRadius
        self.applyShadow(withColor: color, offSetSize: offSetSize, opacity: opacity, radius: radius)
    }
    
    func applyGradient(colors: [UIColor], forGradientLocation gradientLocation: GradientLocation, gradientType: CAGradientLayerType = .axial) {
        DispatchQueue.main.async {
            if colors.count <= 0 {
                return
            }
            if let gradientLayer = self.layer.sublayers?.filter({$0.accessibilityLabel == "gradientLayer"}).first {
                gradientLayer.removeAllAnimations()
                gradientLayer.removeFromSuperlayer()
            }
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.type = gradientType
            gradientLayer.frame = self.bounds
            gradientLayer.accessibilityLabel = "gradientLayer"
            gradientLayer.colors = colors.map({$0.cgColor})
            gradientLayer.startPoint = gradientLocation.position.startPosition
            gradientLayer.endPoint = gradientLocation.position.endPosition
            //        self.layer.addSublayer(gradientLayer)
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func applyDashedBorder(_ borderWidth: CGFloat = 1, borderColor: UIColor = UIColor.black, cornerRadius: CGFloat = 0) {
        
        self.layoutIfNeeded()
        if self.layer.sublayers?.count ?? 0 > 0 {
            let dashedBorderLayer = self.layer.sublayers!.filter({$0 is CAShapeLayer && $0.accessibilityHint == "dashedBorderLayer"}).first
            dashedBorderLayer?.removeFromSuperlayer()
        }
        
        let dashedBorderLayer = CAShapeLayer()
        dashedBorderLayer.accessibilityHint = "dashedBorderLayer"
        dashedBorderLayer.strokeColor = borderColor.cgColor
        dashedBorderLayer.lineDashPattern = [6, 2]
        dashedBorderLayer.frame = self.bounds
        dashedBorderLayer.fillColor = nil
        if cornerRadius > 0 {
            dashedBorderLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashedBorderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        }
        self.layer.addSublayer(dashedBorderLayer)
        
    }
    
    func applyBottomRightLeftCornerWithShadow(_ cornerRadius: CGFloat = 10, color: UIColor) {
        
        self.layoutIfNeeded()
        if self.layer.sublayers?.count ?? 0 > 0 {
            let shadowLayer = self.layer.sublayers!.filter({$0 is CAShapeLayer && $0.accessibilityHint == "shadowLayer"}).first
            shadowLayer?.removeFromSuperlayer()
        }
        
        self.clipsToBounds = false
        
        let shadowLayer = CAShapeLayer()
        let shadowBounds = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let shadowPath = UIBezierPath(roundedRect: shadowBounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        shadowLayer.accessibilityHint = "shadowLayer"
        shadowLayer.path = shadowPath.cgPath
        shadowLayer.fillColor = self.backgroundColor?.cgColor
        
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        
        let shadowRadius = cornerRadius / 4
        
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: shadowRadius + 2)
        shadowLayer.shadowOpacity = 1.0
        shadowLayer.shadowRadius = shadowRadius
        
        self.layer.insertSublayer(shadowLayer, at: 0)
        
    }
    
    func setEnable(_ isEnable: Bool, withPrimaryColor primaryColor: UIColor = UIColor.blue, usingAlpha: Bool = false) {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = isEnable
            if usingAlpha == true {
                self.backgroundColor = isEnable ? primaryColor : primaryColor.withAlphaComponent(0.5)
            } else {
                self.backgroundColor = isEnable ? primaryColor : UIColor.lightText
            }
        }
    }
    
    @discardableResult
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func loadXib() {
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
    }
    
    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil) {
            return image!
        }
        return UIImage()
    }
    
}

extension UIViewController {
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: Bundle.main)
        }
        return instantiateFromNib()
    }
    
    @objc func orientationChanged() {}
    
    func addChildController(_ child: UIViewController, containerView: UIView, frame: CGRect? = nil) {
        self.addChild(child)
        if let frame = frame {
            child.view.frame = frame
        }
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
        self.setChildControllerConstraint(child, containerView: containerView)
    }
    
    fileprivate func setChildControllerConstraint(_ child: UIViewController, containerView: UIView) {
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        child.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
    }
    
    func removeChildController() {
        self.children.forEach { (vc) in
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }
    
}

extension UISegmentedControl {
    
    @IBInspectable
    var fontSize: CGFloat {
        get {
            let titleTextAttributes = self.titleTextAttributes(for: .normal)
            let font = titleTextAttributes?[NSAttributedString.Key.font] as? UIFont
            return font?.pointSize ?? 17
        }
        set {
            let font = UIFont.font(UIFont.Font.OpenSansRegular, fontSize: newValue)
            self.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
    }
    
    func updateAppearanceForiOS13() {
        if #available(iOS 13.0, *) {
            self.backgroundColor = UIColor.lightText
            self.selectedSegmentTintColor = UIColor.blue
            self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.font(UIFont.Font.OpenSansSemiBold, fontSize: 17).getFontTextStyled(.footnote), NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
            self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.font(UIFont.Font.OpenSansSemiBold, fontSize: 17).getFontTextStyled(.footnote), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        } else {
            DispatchQueue.main.async {
                self.tintColor = UIColor.blue
                self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.font(UIFont.Font.OpenSansSemiBold, fontSize: 17).getFontTextStyled(.footnote)], for: .normal)
                self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.font(UIFont.Font.OpenSansSemiBold, fontSize: 17).getFontTextStyled(.footnote)], for: .selected)
            }
        }
    }
    
}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    class func getDefaultNavController(withRootController rootController: UIViewController) -> UINavigationController {
        let navController = UINavigationController.init(rootViewController: rootController)
        navController.navigationBar.updateAppearanceForiOS13()
        return navController
    }
    
}

extension UINavigationBar {
    
    func updateAppearanceForiOS13() {
        if #available(iOS 13.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [.font: UIFont.font(UIFont.Font.OpenSansSemiBold, fontSize: 17).getFontTextStyled(.headline), .foregroundColor: UIColor.white]
            navigationBarAppearance.largeTitleTextAttributes = [.font: UIFont.font(UIFont.Font.OpenSansSemiBold, fontSize: 17).getFontTextStyled(.largeTitle), .foregroundColor: UIColor.white]
            navigationBarAppearance.backgroundColor = UIColor.blue
            self.standardAppearance = navigationBarAppearance
            self.scrollEdgeAppearance = navigationBarAppearance
            self.tintColor = UIColor.white
        } else {
            DispatchQueue.main.async {
                self.backgroundColor = UIColor.blue
                self.barTintColor = UIColor.blue
                self.tintColor = UIColor.white
                self.isTranslucent = false
            }
        }
    }
    
}

extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let statusBarHeight: CGFloat = AppConstant.appDelegate.window?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
            let statusbarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: statusBarHeight))
            statusbarView.accessibilityIdentifier = "CustomStatusBar"
            statusbarView.backgroundColor = UIColor.blue
            if let view = AppConstant.appDelegate.window?.subviews.first(where: {$0.accessibilityIdentifier == "CustomStatusBar"}) {
                view.removeFromSuperview()
            }
            AppConstant.appDelegate.window?.addSubview(statusbarView)
            return statusbarView
        } else if let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView {
            return statusBar
        }
        return nil
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint.init(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint.init(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y);
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
        
    }
    
}

extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
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
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
                case "iPhone11,8":                              return "iPhone XR"
                case "iPhone12,1":                              return "iPhone 11"
                case "iPhone12,3":                              return "iPhone 11 Pro"
                case "iPhone12,5":                              return "iPhone 11 Pro Max"
                case "iPhone12,8":                              return "iPhone SE (2nd generation)"
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
                case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
                case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
                case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
                case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
                case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
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
