//
//  SettingsBundleManager.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation

struct SettingsBundleManager {
    
    fileprivate enum Key: String {
        case Version = "VERSION_KEY"
        case Build = "BUILD_KEY"
        case ResetApp = "RESET_APP_KEY"
    }
    
    static func setVersionAndBuildData() {
        UserDefaults.saveString(AppConstant.appVersionNumber, forKey: Key.Version.rawValue)
        UserDefaults.saveString(AppConstant.appBuildNumber, forKey: Key.Build.rawValue)
    }
    
    static func checkAndResetApp() {
        if UserDefaults.getBool(forKey: Key.ResetApp.rawValue) {
            guard let appDomain: String = Bundle.main.bundleIdentifier else {return}
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            APIManager.shared.performLogout()
            CoreDataManager.shared.resetAllData()
            UserDefaults.saveBool(false, forKey: Key.ResetApp.rawValue)
            SettingsBundleManager.setVersionAndBuildData()
        }
    }
    
}
