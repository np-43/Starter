//
//  ArrayExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import SwiftyJSON

extension Array {
    
    func toJSON() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            let jsonString = String.init(data: data, encoding: .utf8) ?? ""
            return jsonString
        } catch {
            print("Error converting to array:\n\(error.localizedDescription)")
        }
        return ""
    }
    
    static func array(fromJSONString jsonString: String?) -> [Any]? {
        if GeneralUtility.isNonEmptyString(jsonString) {
            return JSON.init(parseJSON: jsonString!).arrayObject
        }
        return nil
    }
    
    mutating func move(at: Index, to: Index) {
        let element = self.remove(at: at)
        self.insert(element, at: to)
    }
    
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
}

extension Sequence where Iterator.Element: Hashable {
    
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
    
}
