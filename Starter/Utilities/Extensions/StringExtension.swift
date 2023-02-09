//
//  StringExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit

extension String {
    
    mutating func encodeURL() {
        self = self.encodedURL()
    }
    
    mutating func decodeURL() {
        self = self.decodedURL()
    }
    
    mutating func encodeURLQuery() {
        self = self.encodedURLQuery()
    }
    
    func encodedURL() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? self
    }
    
    func decodedURL() -> String {
        return self.removingPercentEncoding ?? self
    }
    
    func encodedURLQuery() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
    
    static func base64Encode(_ data: Data?) -> String {
        if data != nil {
            return data!.base64EncodedString()
        }
        return ""
    }
    
    static func base64Encode(_ image: UIImage) -> String {
        let data = image.pngData()
        return String.base64Encode(data)
    }
    
    static func base64Encode(_ filepath: String) -> String {
        do {
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath: filepath))
            return String.base64Encode(data)
        } catch let error {
            print(error)
        }
        return ""
    }
    
    func utf8Encoded() -> Data {
        return self.data(using: String.Encoding.utf8)!
    }
    
    mutating func encodeBase64() {
        self = self.utf8Encoded().base64EncodedString()
    }
    
    func encodedBase64() -> String {
        return self.utf8Encoded().base64EncodedString()
    }
    
    mutating func decodeBase64() {
        self = self.decodedBase64()
    }
    
    func decodedBase64() -> String {
        if let decodedData = Data.init(base64Encoded: self) {
            return String.init(data: decodedData, encoding: String.Encoding.utf8) ?? self
        }
        return self
    }
    
    func trimmed() -> String {
        let whitespace = CharacterSet.whitespacesAndNewlines
        let stringTrimmed = self.trimmingCharacters(in: whitespace)
        let stringWithoutSpace = stringTrimmed.replacingOccurrences(of: " ", with: "")
        return stringWithoutSpace
    }
    
    mutating func trim() {
        self = self.trimmed()
    }
    
    func toInt() -> Int {
        let intValue = Int(self)
        return intValue ?? 0
    }
    
    func toDouble() -> Double {
        return Double.numberFormatter.number(from: self)?.doubleValue ?? 0
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        return results.map { String($0) }
    }
    
    func getHyperlinkText() -> NSAttributedString{
        let color = UIColor.blue
        let attributedText = NSMutableAttributedString(string: self)
        let textRange = NSMakeRange(0, self.count)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor , value: color, range: textRange)
        return attributedText

    }
    
    
    func toURL() -> URL? {
        let url = URL.init(string: self)
        return url
    }
    
    mutating func encodeURLLastPathComponent() {
        var arrayComponents = self.components(separatedBy: "/")
        let lastComponent = arrayComponents.popLast() ?? ""
        arrayComponents.append(lastComponent.encodedURL())
        self = arrayComponents.joined(separator: "/")
    }
    
    func encodedURLLastPathComponent() -> String {
        var arrayComponents = self.components(separatedBy: "/")
        let lastComponent = arrayComponents.popLast() ?? ""
        arrayComponents.append(lastComponent.encodedURL())
        return arrayComponents.joined(separator: "/")
    }
    
    static func currenyString(fromDouble value: Double?) -> String {
        if value == nil {
            return ""
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
        if let string = numberFormatter.string(from: NSNumber.init(value: value!)) {
            return string
        }
        return ""
    }
    
    func currencyToDouble() -> Double {
        if self.count <= 0 {
            return 0
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
        let number = numberFormatter.number(from: self)
        return number?.doubleValue ?? 0
    }
    
    static func fromDouble(_ value: Double?) -> String {
        if value == nil {
            return ""
        }
        return "\(value!)"
    }
    
    static func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
        
    }
    
//    var localized: String {
//        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
//    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedString
        } catch {
            return nil
        }
    }
    
}

extension Double {
    
    static var numberFormatter: NumberFormatter = {
        let tempNumberFormatter = NumberFormatter.init()
        tempNumberFormatter.numberStyle = .decimal
        return tempNumberFormatter
    }()
    
    var string: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func round(upto: Int) -> Double {
        Double.numberFormatter.maximumFractionDigits = upto
        Double.numberFormatter.roundingMode = .halfUp
        let string = Double.numberFormatter.string(from: NSNumber.init(value: self))
        return string?.toDouble() ?? 0
    }
    
    func toString(upto: Int = 2) -> String? {
        let string = String(format: "%.\(upto)f", self)
        return string
    }
    
    func toPercentageString() -> String? {
        let string = self.round(upto: 2).string + " %"
        return string
    }
    
    func getNegativeValue() -> Double {
        if (self == -0 || self == 0) {
            return 0
        }
        if self > 0 {
            return (0 - self)
        }
        return self
    }
    
    mutating func toNegativeValue() {
        self = self.getNegativeValue()
    }
    
    func getPositiveValue() -> Double {
        if (self == -0 || self == 0) {
            return 0
        }
        if self < 0 {
            return (0 - self)
        }
        return self
    }
    
    mutating func toPositiveValue() {
        self = self.getPositiveValue()
    }
    
}

extension Int {
    
    func getNegativeValue() -> Int {
        if (self == -0 || self == 0) {
            return 0
        }
        if self > 0 {
            return (0 - self)
        }
        return self
    }
    
    mutating func toNegativeValue() {
        self = self.getNegativeValue()
    }
    
    func getPositiveValue() -> Int {
        if (self == -0 || self == 0) {
            return 0
        }
        if self < 0 {
            return (0 - self)
        }
        return self
    }
    
    mutating func toPositiveValue() {
        self = self.getPositiveValue()
    }
    
}

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
    #endif
}
