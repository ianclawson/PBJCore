//
//  DateFormatHelper.swift
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
    
    func dateFormatter() -> DateFormatter {
        switch self {
        case .isoMil:   return DateFormatHelper.isoMil
        case .isoSec:   return DateFormatHelper.isoSec
        case .realmDate:        return DateFormatHelper.realmDate
        case .realmDateTime:    return DateFormatHelper.realmDateTime
        case .displayTime:                  return DateFormatHelper.displayTime
        case .displayMonthDay:              return DateFormatHelper.displayMonthDay
        case .displayMonthDayCommaTime:     return DateFormatHelper.displayMonthDayCommaTime
        case .displayMonthDayCommaYear:     return DateFormatHelper.displayMonthDayCommaYear
        case .displayDayOfWeekMonthDayTime: return DateFormatHelper.displayDayOfWeekMonthDayTime
        }
    }
}

public struct DateFormatHelper {
    
    static func date(from: String, format: DateFormatType) -> Date? {
        return format.dateFormatter().date(from: from)
    }
    
    static func string(from: Date, format: DateFormatType) -> String {
        return format.dateFormatter().string(from: from)
    }
    
    // iso
    public static let isoMil: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    public static let isoSec: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    // realm
    public static let realmDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    public static let realmDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
        // dateTimeFormatter.timeZone = TimeZone(name: "GMT")
        // this line resolved me the issue of getting one day
        // less than the selected date
    }()
    
    // local
    public static let displayTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    public static let displayMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    public static let displayMonthDayCommaTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
    
    public static let displayMonthDayCommaYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        return formatter
    }()
    
    public static let displayDayOfWeekMonthDayTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM d h:mm a"
        return formatter
    }()
}

