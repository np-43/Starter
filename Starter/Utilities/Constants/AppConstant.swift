//
//  AppConstant.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit

struct AppConstant {
    
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let appDisplayName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    static let appVersionNumber: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static let appBuildNumber: String = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""
    
    static let navigationTitleAppName: String = AppConstant.appDisplayName
    
    struct Device {
        #if targetEnvironment(simulator)
        static let isSimulator = true
        #else
        static let isSimulator = false
        #endif
        static let isIpad = (UIDevice.current.userInterfaceIdiom == .pad) ? true : false
        static let isIphone = (UIDevice.current.userInterfaceIdiom == .phone) ? true : false
    }
    
}

extension AppConstant {
    
    struct CommonErrorMessage {
        static let somethingWentWrong = "Something went wrong"
    }
    
    struct NoDataMessage {
        static let defaultMessage = "No data available"
        static let noDataFound = "No data found"
    }
    
}

extension AppConstant {
    
    struct Color {
        static let primary: UIColor = UIColor.blue//UIColor.init(named: "PrimaryWNB")!
    }
    
    struct Image {
        static let icBack = UIImage.init(named: "ic_back")!
        static let icMenu = UIImage.init(named: "ic_menu")!
    }
    
    struct UserDefaultsKey {
        struct LoginUser {
            static let email = "email"
            static let password = "password"
        }
        static let token = "token"
    }
    
}
