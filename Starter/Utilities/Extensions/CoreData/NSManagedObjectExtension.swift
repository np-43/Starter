//
//  NSManagedObjectExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    func evaluateValue(_ value: Any?, forNSAttributeType attributeType: NSAttributeType) -> Any {
        if value == nil || value is NSNull {
            if (attributeType == NSAttributeType.integer16AttributeType || attributeType == NSAttributeType.integer32AttributeType || attributeType == NSAttributeType.integer64AttributeType) {
                return 0
            } else if (attributeType == NSAttributeType.floatAttributeType || attributeType == NSAttributeType.doubleAttributeType) {
                return 0.0
            } else if (attributeType == NSAttributeType.booleanAttributeType) {
                return false
            }
            return ""
        } else {
            if (attributeType == NSAttributeType.integer16AttributeType || attributeType == NSAttributeType.integer32AttributeType || attributeType == NSAttributeType.integer64AttributeType) {
                if let result = value as? Int {
                    return result
                }
                if value is String {
                    return Int(value as! String) as Any
                }
                if value is Double {
                    return Int(value as! Double) as Any
                }
            } else if (attributeType == NSAttributeType.floatAttributeType || attributeType == NSAttributeType.doubleAttributeType) {
                if let result = value as? Double {
                    return result
                }
                if value is String {
                    return Double(value as! String) as Any
                }
                if value is Int {
                    return  Double(value as! Int) as Any
                }
            } else if (attributeType == NSAttributeType.booleanAttributeType) {
                if value is String {
                    return Bool.init(value as! String) as Any
                }
                if (value is Int) {
                    return Bool.init(exactly: NSNumber.init(value: value as! Int)) as Any
                }
                if (value is Double) {
                    return Bool.init(exactly: NSNumber.init(value: value as! Double)) as Any
                }
            } else if (attributeType == NSAttributeType.stringAttributeType) {
                return String(describing: value) as Any
            }
            return "" as Any
        }
    }
    
    func toDictionary() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        for attribute in self.entity.attributesByName {
            //check if value is present, then add key to dictionary so as to avoid the nil value crash
            if let value = self.value(forKey: attribute.key) {
                if (value is String || value is Int || value is Double) {
                    dictionary[attribute.key] = value
                }
            }
        }
        return dictionary
        
    }
    
}
