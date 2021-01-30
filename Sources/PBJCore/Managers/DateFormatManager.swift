//
//  DateFormatManager.swift
//  stars2apples
//
//  Created by Ian Clawson on 3/8/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation

public class DateFormatManager {
    public static let shared = DateFormatManager()
    
    // iso
    public let isoMil: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    public let isoSec: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    // realm
    public let realmDateOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    public let realmDateAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
        // dateTimeFormatter.timeZone = TimeZone(name: "GMT")
        // this line resolved me the issue of getting one day
        // less than the selected date
    }()
    
    // local
    public let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    public let monthAndDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    public let monthDayAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
    
    public let dayOfWeekMonthDayAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM d h:mm a"
        return formatter
    }()
    
    public let monthDayCommaYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        return formatter
    }()
}

