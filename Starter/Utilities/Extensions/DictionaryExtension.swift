//
//  DictionaryExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import SwiftyJSON

extension Dictionary {
    
    func toJSON() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            let jsonString = String.init(data: data, encoding: .utf8) ?? ""
            return jsonString
        } catch {
            print("Error converting to class/struct:\n\(error.localizedDescription)")
        }
        return ""
    }
    
    static func dictionary(fromJSONString jsonString: String?) -> [String: Any] {
        if GeneralUtility.isNonEmptyString(jsonString) {
            return JSON.init(parseJSON: jsonString!).dictionaryObject ?? [:]
        }
        return [:]
    }
    
    static func == <K, V>(left: [K:V], right: [K:V]) -> Bool {
        return NSDictionary(dictionary: left).isEqual(to: right)
    }
    
    func decodable<T>(_ type: T.Type) -> T? where T: Decodable {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .init())
            let decodable = try JSONDecoder.init().decode(type, from: data)
            return decodable
        } catch {
            print("Error converting to class/struct:\n\(error.localizedDescription)")
        }
        return nil
    }
    
}

