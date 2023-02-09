//
//  NPSideMenuManager.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import UIKit
import SideMenu

class NPSideMenuManager: NSObject {

//    static let shared: NPSideMenuManager = {
//        let instance = NPSideMenuManager.init()
//        return instance
//    }()
    
    //Initializer access level change
    fileprivate override init(){}
    
    var leftSideMenuNavigationController: SideMenuNavigationController? {
        return SideMenuManager.default.leftMenuNavigationController
    }
    
    var rightSideMenuNavigationController: SideMenuNavigationController? {
        return SideMenuManager.default.rightMenuNavigationController
    }
    
}
// MARK:- Dependency injection
protocol NPSideMenuManagerInjection {
    var sideMenuManager: NPSideMenuManager {get}
}

fileprivate var sharedManager: NPSideMenuManager? = NPSideMenuManager.init()

extension NPSideMenuManagerInjection {
    
    var sideMenuManager: NPSideMenuManager {
        if sharedManager == nil {
            self.reinitNPSideMenuManager()
        }
        return sharedManager!
    }
    
    fileprivate func reinitNPSideMenuManager() {
        sharedManager = NPSideMenuManager.init()
    }
    
    func purgeNPSideMenuManager() {
        sharedManager = nil
    }
    
}

extension NPSideMenuManager {
    
    enum Side {
        case left
        case right
    }
    
}

extension NPSideMenuManager {
    
    func addSideMenu(on side: Side = .left, withIdentifier identifier: String, isGestureEnable: Bool = true, storyboard: Storyboard = .main) {
        guard let sideMenuNavigationController = UIStoryboard.getViewController(fromStoryboard: storyboard, withIdentifier: identifier) as? SideMenuNavigationController else {return}
        sideMenuNavigationController.menuWidth = (UIScreen.main.bounds.width * (AppConstant.Device.isIphone ? 0.7 : 0.4))
        switch side {
        case .left:     SideMenuManager.default.leftMenuNavigationController = sideMenuNavigationController
        case .right:    SideMenuManager.default.rightMenuNavigationController = sideMenuNavigationController
        }
        
        sideMenuNavigationController.presentationStyle = .menuSlideIn
        if #available(iOS 13.0, *) {
            sideMenuNavigationController.presentationStyle.backgroundColor = UIColor.black//NPThemeManager.shared.primaryColor()
        }
        sideMenuNavigationController.presentationStyle.presentingEndAlpha = 0.35
        
        if isGestureEnable == true {
            if let navigationController = GeneralUtility.currentViewController?.navigationController {
                SideMenuManager.default.addPanGestureToPresent(toView: navigationController.navigationBar)
                SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: navigationController.view)
            }
        }
    }
    
    func removeSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = nil
        SideMenuManager.default.rightMenuNavigationController = nil
    }
    
}
