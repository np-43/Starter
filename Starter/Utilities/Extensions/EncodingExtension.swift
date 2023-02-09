//
//  EncodingExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation

extension Encodable {
    
    func dictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder.init().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dictionary
        } catch {
            print("Error converting to dictionary:\n\(error.localizedDescription)")
        }
        return nil
    }
    
}

protocol BaseCodable: Codable {
    
    var dictionary: [String: Any] { get }
    
}

extension BaseCodable {
    
    var dictionary: [String: Any] {
        let mirror = Mirror.init(reflecting: self)
        let dict = Dictionary.init(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, Any)? in
            guard let key = label else {return nil}
            return (key, value)
        }).compactMap({$0}))
        return dict
    }
    
}
