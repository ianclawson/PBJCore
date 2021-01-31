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

public class DateFormatManager {
    
    public static let shared = DateFormatManager()
    
    // date formatters are expensive; share one across the entire application
    let formatter = DateFormatter()
    
    func date(from: String, format: DateFormatType) -> Date? {
        self.formatter.dateFormat = format.formatString()
        return formatter.date(from: from)
    }
    
    func string(from: Date, format: DateFormatType) -> String {
        self.formatter.dateFormat = format.formatString()
        return formatter.string(from: from)
    }
}

// separate/duplicate functions for convenience in case I
// get lazy and forget that they belong to `DateFormatManager`
// and because it's nice not to type `DateFormatManager.shared`
public extension DateFormatter {
    class func date(from: String, format: DateFormatType) -> Date? {
        return DateFormatManager.shared.date(from: from, format: format)
    }
    
    class func string(from: Date, format: DateFormatType) -> String {
        return DateFormatManager.shared.string(from: from, format: format)
    }
}
