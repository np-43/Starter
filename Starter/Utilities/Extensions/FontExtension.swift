//
//  FontExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit

extension UIFont {
    
    enum Font {
        
        case OpenSansLight
        case OpenSansRegular
        case OpenSansMedium
        case OpenSansSemiBold
        case OpenSansBold
        
        var name: String {
            switch self {
            case .OpenSansLight:          return "OpenSans-Light"
            case .OpenSansRegular:        return "OpenSans-Regular"
            case .OpenSansMedium:         return "OpenSans-Semibold"
            case .OpenSansSemiBold:       return "OpenSans-Semibold"
            case .OpenSansBold:           return "OpenSans-Bold"
            }
        }
        
    }
    
    class func font(_ font: Font, fontSize: CGFloat) -> UIFont {
        
        var customFont = UIFont.init(name: font.name, size: fontSize)
        
        if customFont == nil {
            switch font {
            case .OpenSansLight:        customFont = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light)
            case .OpenSansRegular:      customFont = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
            case .OpenSansMedium:       customFont = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
            case .OpenSansSemiBold:     customFont = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)
            case .OpenSansBold:         customFont = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.bold)
            }
        }
        
        return customFont!
        
    }
    
    func getFontTextStyled(_ textStyle: UIFont.TextStyle) -> UIFont {
//        let fontSize = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        let fontSize = UIFont.getFontSize(forTextStyle: textStyle)
        return self.withSize(fontSize)
    }
    
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("  ->  \(name)")
            }
        }
    }
    
    class func getFontSize(forTextStyle textStyle: UIFont.TextStyle) -> CGFloat {
        switch textStyle {
        case .largeTitle:   return 34
        case .title1:       return 28
        case .title2:       return 22
        case .title3:       return 20
        case .headline:     return 17
        case .body:         return 17
        case .callout:      return 16
        case .subheadline:  return 15
        case .footnote:     return 13
        case .caption1:     return 12
        case .caption2:     return 11
        default:            return 17
        }
    }
    
}
