//
//  CommonEnums.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit

enum TextStyle {
    
    case largeTitle     // 34
    case title1         // 28
    case title2         // 22
    case title3         // 20
    case headline       // 17
    case body           // 17
    case callout        // 16
    case subheadline    // 15
    case footnote       // 13
    case caption1       // 12
    case caption2       // 11
    case none
    
    var value: Int {
        switch self {
        case .largeTitle:   return 1
        case .title1:       return 2
        case .title2:       return 3
        case .title3:       return 4
        case .headline:     return 5
        case .body:         return 6
        case .callout:      return 7
        case .subheadline:  return 8
        case .footnote:     return 9
        case .caption1:     return 10
        case .caption2:     return 11
        case .none:         return 0
        }
    }
    
    var textStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle:   return .largeTitle
        case .title1:       return .title1
        case .title2:       return .title2
        case .title3:       return .title3
        case .headline:     return .headline
        case .body:         return .body
        case .callout:      return .callout
        case .subheadline:  return .subheadline
        case .footnote:     return .footnote
        case .caption1:     return .caption1
        case .caption2:     return .caption2
        case .none:         return .init(rawValue: "none")
        }
    }
    
}
