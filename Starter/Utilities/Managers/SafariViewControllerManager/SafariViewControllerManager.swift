//
//  SafariViewControllerManager.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import UIKit
import SafariServices

class SafariViewControllerManager: NSObject {

//    static let shared: SafariViewControllerManager = {
//        let instance = SafariViewControllerManager.init()
//        return instance
//    }()
    
    //Initializer access level change
    fileprivate override init(){}
    
}

// MARK:- Dependency injection
protocol SafariViewControllerManagerInjection {
    var safariVCManager: SafariViewControllerManager {get}
}

fileprivate var sharedManager: SafariViewControllerManager? = SafariViewControllerManager.init()

extension SafariViewControllerManagerInjection {
    
    var safariVCManager: SafariViewControllerManager {
        if sharedManager == nil {
            self.reinitSafariViewControllerManager()
        }
        return sharedManager!
    }
    
    fileprivate func reinitSafariViewControllerManager() {
        sharedManager = SafariViewControllerManager.init()
    }
    
    func purgeSafariViewControllerManager() {
        sharedManager = nil
    }
    
}

extension SafariViewControllerManager: SFSafariViewControllerDelegate {
    
    func presentSafariViewController(from: UIViewController, withURL stringURL: String?) {
        if let url = URL.init(string: stringURL ?? "") {
            let safariVC = SFSafariViewController.init(url: url)
            safariVC.preferredBarTintColor = UIColor.blue
            safariVC.preferredControlTintColor = UIColor.white
            safariVC.delegate = from as? SFSafariViewControllerDelegate
            from.present(safariVC, animated: true) {
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
        }
    }
    
}
