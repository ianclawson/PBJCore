//
//  DateFormatManager.swift
//  PBJCore
//
//  Created by Ian Clawson on 3/8/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation

public enum DateFormatType {
    case isoMil
    case isoSec
    case realmDate
    case realmDateTime
    case displayTime
    case displayMonthDay
    case displayMonthDayCommaTime
    case displayDayOfWeekMonthDayTime
    case displayMonthDayCommaYear
    
    func formatString() -> String {
        switch self {
        case .isoMil:                       return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .isoSec:                       return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .realmDate:                    return "yyyy-MM-dd"
        case .realmDateTime:                return "yyyy-MM-dd HH:mm:ss"
        case .displayTime:                  return "h:mm a"
        case .displayMonthDay:              return "MMM d"
        case .displayMonthDayCommaTime:     return "MMM d, h:mm a"
        case .displayMonthDayCommaYear:     return "MMMM dd, YYYY"
        case .displayDayOfWeekMonthDayTime: return "E MMM d h:mm a"
        }
    }
}

public extension DateFormatter {
    class func date(from: String, format: DateFormatType) -> Date? {
        DateFormatManager.shared.formatter.dateFormat = format.formatString()
        return DateFormatManager.shared.formatter.date(from: from)
    }
    
    class func string(from: Date, format: DateFormatType) -> String {
        DateFormatManager.shared.formatter.dateFormat = format.formatString()
        return DateFormatManager.shared.formatter.string(from: from)
    }
}

public class DateFormatManager {
    public static let shared = DateFormatManager()
    
    // date formatters are expensive; share one across the entire application
    let formatter = DateFormatter()
    
    // separate/duplicate functions for convenience in case I
    // get lazy and forget that they belong to `DateFormatter`
    func date(from: String, format: DateFormatType) -> Date? {
        return DateFormatter.date(from: from, format: format)
    }
    func string(from: Date, format: DateFormatType) -> String {
        return DateFormatter.string(from: from, format: format)
    }
}
