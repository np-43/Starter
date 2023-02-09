//
//  DateExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation

enum DateFormat {
    
    case defaultDateTimeUS
    case defaultDateTimeUK
    case defaultDateUS
    case defaultDateUK
    case time24HrsWithSeconds
    case time24HrsWithoutSeconds
    case time12HrsWithSeconds
    case time12HrsWithoutSeconds
    case defaultDateTimeUK12HrsWithoutSeconds
    case MMMMdd
    case MMMdd
    case dd
    case monthNumeric1Digit
    case monthNumeric2Digits
    case year2Digits
    case year4Digits
    case yyyyMMddWithDash
    case uniqueString
    case EEE
    case EEEE
    case yyyyMMddHHmmssWithDashSpaceColon
    case yyyyMMddTHHmmssSSSZ //2019-07-23T11:49:46.000Z
    case MMddyyyy
    case yyyyMMdd
    case yyyyMMddHHmmss // Batch Close Format
    case userBased(String)
    
    var value: String {
        switch self {
            case .defaultDateTimeUS:                            return "MM-dd-yyyy HH:mm:ss"
            case .defaultDateTimeUK:                            return "dd-MM-yyyy HH:mm:ss"
            case .defaultDateUS:                                return "MM-dd-yyyy"
            case .defaultDateUK:                                return "dd-MM-yyyy"
            case .time24HrsWithSeconds:                         return "HH:mm:ss"
            case .time24HrsWithoutSeconds:                      return "HH:mm"
            case .time12HrsWithSeconds:                         return "hh:mm:ss a"
            case .time12HrsWithoutSeconds:                      return "hh:mm a"
            case .defaultDateTimeUK12HrsWithoutSeconds:         return "dd-MM-yyyy hh:mm a"
            case .MMMMdd:                                       return "MMMM dd"
            case .MMMdd:                                        return "MMM dd"
            case .dd:                                           return "dd"
            case .monthNumeric1Digit:                           return "M"
            case .monthNumeric2Digits:                          return "MM"
            case .year2Digits:                                  return "yy"
            case .year4Digits:                                  return "yyyy"
            case .yyyyMMddWithDash:                             return "yyyy-MM-dd"
            case .uniqueString:                                 return "ddMMyyyyHHmmssSSSS"
            case .EEE:                                          return "EEE"
            case .EEEE:                                         return "EEEE"
            case .yyyyMMddHHmmssWithDashSpaceColon:             return "yyyy-MM-dd HH:mm:ss"
            case .yyyyMMddTHHmmssSSSZ:                          return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            case .MMddyyyy:                                     return "MMddyyyy"
            case .yyyyMMdd:                                     return "yyyyMMdd"
            case .yyyyMMddHHmmss:                               return "yyyyMMddHHmmss"
            case .userBased:                                    return ""
        }
    }
    
}

extension Date {
    
    static var dateFormatter: DateFormatter {
        let tempDateFormatter = DateFormatter.init()
        tempDateFormatter.locale = Locale.current
        return tempDateFormatter
    }
    
    static var calendar: Calendar {
        let tempCalendar = Calendar.current
        return tempCalendar
    }
    
    static func getTimeZone(isUTC: Bool = false) -> TimeZone {
        if isUTC == true {
            return TimeZone.init(identifier: "UTC") ?? TimeZone.autoupdatingCurrent
        }
        return TimeZone.autoupdatingCurrent
    }
    
    static func getDateFormatValue(_ dateFormat: DateFormat) -> String {
        switch dateFormat {
            case .userBased(let value):     return value
            default:                        return dateFormat.value
        }
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    static func onlyDate() -> Date {
        let stringDate = Date.stringDate(fromDate: Date.init(), dateFormat: DateFormat.yyyyMMdd)
        return Date.date(fromString: stringDate, dateFormat: DateFormat.yyyyMMdd) ?? Date.init()
    }
    
    static func date(fromString stringDate: String?, dateFormat: DateFormat, isUTC: Bool = false) -> Date? {
        if ((stringDate?.count ?? 0) <= 0) {
            return nil
        }
        let dateFormatter = Date.dateFormatter
        dateFormatter.dateFormat = Date.getDateFormatValue(dateFormat)
        //        if isUTC == true {
        //            dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        //        }
        dateFormatter.timeZone = Date.getTimeZone(isUTC: isUTC)
        let date = dateFormatter.date(from: stringDate!)
        return date
    }
    
    static func stringDate(fromDate date: Date?, dateFormat: DateFormat, isUTC: Bool = false) -> String? {
        if date == nil {
            return nil
        }
        let dateFormatter = Date.dateFormatter
        dateFormatter.dateFormat = Date.getDateFormatValue(dateFormat)
        //        if isUTC == true {
        //            dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        //        }
        dateFormatter.timeZone = Date.getTimeZone(isUTC: isUTC)
        let stringDate = dateFormatter.string(from: date!)
        return stringDate
    }
    
    static func stringDate(fromString stringDate: String?, sourceDateFormat: DateFormat, destinationDateFormat: DateFormat, isUTC: Bool = false) -> String? {
        if isUTC == true {
            let tempDate = Date.date(fromString: stringDate, dateFormat: sourceDateFormat, isUTC: isUTC)
            let finalStringData = Date.stringDate(fromDate: tempDate, dateFormat: destinationDateFormat)
            return finalStringData
        }
        let tempDate = Date.date(fromString: stringDate, dateFormat: sourceDateFormat)
        let finalStringData = Date.stringDate(fromDate: tempDate, dateFormat: destinationDateFormat)
        return finalStringData
    }
    
    static func date(fromTimestamp timestamp: Double?) -> Date? {
        if timestamp == nil {
            return nil
        }
        let date = Date.init(timeIntervalSince1970: timestamp!)
        return date
    }
    
    static func stringDate(fromTimestamp timestamp: Double?, dateFormat: DateFormat, isUTC: Bool = true) -> String? {
        if timestamp == nil || timestamp == 0 {
            return nil
        }
        let date = Date.init(timeIntervalSince1970: timestamp!)
        return Date.stringDate(fromDate: date, dateFormat: dateFormat, isUTC: isUTC)
    }
    
    static func toAge(fromString stringDate: String?, dateFormat: DateFormat) -> Int {
        let age = Date.date(fromString: stringDate, dateFormat: dateFormat)?.toAge()
        return age ?? 0
    }
    
    func toAge() -> Int {
        let dateComponents = Date.calendar.dateComponents([.year], from: self, to: Date.init())
        let age = dateComponents.year ?? 0
        return age
    }
    
    static func date(fromAge age: Int) -> Date? {
        var components = Date.calendar.dateComponents([.year, .month, .day], from: Date.init())
        components.year = components.year! - age
        let ageYearDate = Date.calendar.date(from: components)!
        let date = Date.calendar.date(byAdding: .day, value: -1, to: ageYearDate)!
        return date
    }
    
    static func currentMonthFirstDate() -> Date! {
        var components = Date.calendar.dateComponents([.year, .month], from: Date.init())
        components.timeZone = Date.getTimeZone()
        let date = Date.calendar.date(from: components)!
        return date
    }
    
    static func currentMonthFirstDate(dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.currentMonthFirstDate(), dateFormat: dateFormat)
    }
    
    static func currentMonthLastDate() -> Date {
        var components = DateComponents.init()
        components.month = 1
        components.day = -1
        let date = Date.calendar.date(byAdding: components, to: Date.currentMonthFirstDate())!
        return date
    }
    
    static func currentMonthLastDate(dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.currentMonthLastDate(), dateFormat: dateFormat)
    }
    
    static func currentYearFirstDate() -> Date! {
        var components = Date.calendar.dateComponents([.year, .month], from: Date.init())
        components.timeZone = Date.getTimeZone()
        components.month = 1
        components.year = (components.year ?? 0) + 1
        components.day = 1
        let date = Date.calendar.date(from: components)!
        return date
    }
    
    static func currentYearFirstDate(dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.currentYearFirstDate(), dateFormat: dateFormat)
    }
    
    static func currentYearLastDate() -> Date! {
        var components = Date.calendar.dateComponents([.year], from: self.currentYearFirstDate())
        components.timeZone = Date.getTimeZone()
        components.year = components.year! + 1
        let firstDateOfNextYear = Date.calendar.date(from: components)!
        let date = Date.calendar.date(byAdding: .day, value: -1, to: firstDateOfNextYear)!
        return date
    }
    
    static func currentYearLastDate(dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.currentYearLastDate(), dateFormat: dateFormat)
    }
    
    static func lastMonthLastDate() -> Date {
        var components = DateComponents.init()
        components.month = 1
        components.day = -1
        let date = Date.calendar.date(byAdding: components, to: Date.firstDateOfLastNumberOfMonths())!
        return date
    }
    
    static func lastMonthLastDate(dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.lastMonthLastDate(), dateFormat: dateFormat)
    }
    
    static func firstDateOfLastNumberOfMonths(_ numberOfMonths: Int = 1) -> Date! {
        let currentMonthDate = Date.currentMonthFirstDate()!
        let date = Date.calendar.date(byAdding: .month, value: (0 - numberOfMonths), to: currentMonthDate)!
        return date
    }
    
    static func firstDateOfLastNumberOfMonths(_ numberOfMonths: Int = 1, dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.firstDateOfLastNumberOfMonths(numberOfMonths), dateFormat: dateFormat)
    }
    
    static func previousYearFirstDate() -> Date! {
        let date = Date.calendar.date(byAdding: .year, value: -1, to: Date.currentYearFirstDate())
        return date
    }
    
    static func previousYearFirstDate(dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.previousYearFirstDate(), dateFormat: dateFormat)
    }
    
    static func previousYearLastDate() -> Date! {
        let date = Date.calendar.date(byAdding: .year, value: -1, to: Date.currentYearLastDate())!
        return date
    }
    
    static func previousYearLastDate(dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.previousYearLastDate(), dateFormat: dateFormat)
    }
    
    static func currentYear() -> Int? {
        let components = Date.calendar.dateComponents([.year], from: Date.init())
        return components.year
    }
    
    static func firstDate(ofYear year: Int) -> Date? {
        var components = Date.calendar.dateComponents([.year, .month], from: Date.init())
        components.month = 1
        components.year = year + 1
        components.day = 1
        let date = Date.calendar.date(from: components)!
        return date
    }
    
    static func firstDate(ofYear year: Int, dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.firstDate(ofYear: year), dateFormat: dateFormat)
    }
    
    static func lastDate(ofYear year: Int) -> Date? {
        var components = Date.calendar.dateComponents([.year], from: self.firstDate(ofYear: year)!)
        components.year = components.year! + 1
        let firstDateOfNextYear = Date.calendar.date(from: components)!
        let date = Date.calendar.date(byAdding: .day, value: -1, to: firstDateOfNextYear)!
        return date
    }
    
    static func lastDate(ofYear year: Int, dateFormat: DateFormat) -> String? {
        return Date.stringDate(fromDate: Date.lastDate(ofYear: year), dateFormat: dateFormat)
    }
    
}

extension TimeInterval {
    
    init(fromTimestamp timestamp: Double) {
        var stringTimestamp = timestamp.string
        if stringTimestamp.contains(".") {
            stringTimestamp = stringTimestamp.components(separatedBy: ".").first ?? stringTimestamp
        }
        if stringTimestamp.count > 10 {
            var multipler: Double = 1
            let additional = stringTimestamp.count - 10
            for _ in 1...additional {
                multipler = multipler * 10
            }
            self = (timestamp / multipler)
            return
        }
        self = timestamp
    }
    
    init(fromDate date: Date) {
        let stringTimeInterval = date.timeIntervalSince1970.string
        if stringTimeInterval.contains(".") {
            let timeInterval = stringTimeInterval.components(separatedBy: ".").first!
            self = timeInterval.toDouble()
        } else {
            self = stringTimeInterval.toDouble()
        }
    }
    
    static func current(isUTC: Bool = false, withBufferTime bufferTime: Double = 0) -> TimeInterval {
        if isUTC == true {
            let date = Date.init()
            let stringDate = Date.stringDate(fromDate: date, dateFormat: DateFormat.defaultDateTimeUS)
            if let currentUTCDate = Date.date(fromString: stringDate, dateFormat: DateFormat.defaultDateTimeUS, isUTC: isUTC) {
                var timeInterval = TimeInterval.init(fromDate: currentUTCDate)
                timeInterval = timeInterval + bufferTime
                return timeInterval
            }
        }
        var timeInterval = TimeInterval.init(fromDate: Date.init())
        timeInterval = timeInterval + bufferTime
        return timeInterval
    }
    
}

extension Date {
    
    static func getCurrentTimeZone(isUTC: Bool = false) -> TimeZone {
        if isUTC == true {
            return TimeZone.init(identifier: "UTC") ?? TimeZone.autoupdatingCurrent
        }
        return TimeZone.current
    }
    
    func currentToUTC() -> Date {
        let timeIntervalDiff = TimeInterval.init(Date.getCurrentTimeZone().secondsFromGMT(for: self) - Date.getCurrentTimeZone(isUTC: true).secondsFromGMT(for: self))
        return self.addingTimeInterval(timeIntervalDiff)
    }
    
    func utcToCurrent() -> Date {
        let timeIntervalDiff = TimeInterval.init(Date.getCurrentTimeZone(isUTC: true).secondsFromGMT(for: self) - Date.getCurrentTimeZone().secondsFromGMT(for: self))
        return self.addingTimeInterval(timeIntervalDiff)
    }
    
    static func currentToUTC(stringDate: String, dateFormat: DateFormat) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.value
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = Date.getCurrentTimeZone()
        
        if let date = dateFormatter.date(from: stringDate) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = dateFormat.value
            
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    static func utcToCurrent(stringDate: String, dateFormat: DateFormat) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.value
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: stringDate) {
            dateFormatter.timeZone = Date.getCurrentTimeZone()
            dateFormatter.dateFormat = dateFormat.value
            
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
}
