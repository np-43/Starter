//
//  StoryboardExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit

enum Storyboard {
    
    case main
    
    var name: String {
        switch self {
        case .main:     return "Main"
        }
    }
    
}

extension UIStoryboard {
    
    class func getStoryboard(from storyboard: Storyboard) -> UIStoryboard {
        return UIStoryboard.init(name: storyboard.name, bundle: nil)
    }
    
    class func getInitialViewController() -> UIViewController? {
        let initialViewController = UIStoryboard.getStoryboard(from: .main).instantiateInitialViewController()
        return initialViewController
    }
    
    class func getViewController(fromStoryboard storyboard: Storyboard, withIdentifier identifier: String) -> UIViewController {
        let viewController = UIStoryboard.getStoryboard(from: storyboard).instantiateViewController(withIdentifier: identifier)
        return viewController
    }
    
}
