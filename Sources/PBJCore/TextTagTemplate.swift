//
//  Template.swift
//  stars2apples
//
//  Created by Ian Clawson on 6/2/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation

@dynamicMemberLookup
struct TextTagTemplate {
    var template : String
    private var data : [String:String]
    var populatedTemplate : String { data.reduce(template) { $0.replacingOccurrences(of: "${\($1.key)}", with: $1.value) } }

    init(template: String, data: [String:String] = [:]) {
        self.template = template
        self.data = data
    }
    
    subscript (dynamicMember member: String) -> CustomStringConvertible? {
        get { data[member] }
        set { data[member] = newValue?.description }
    }
    
    subscript (dynamicMember member: String) -> Date {
        get { dateFormatter.date(from: data[member] ?? "") ?? Date(timeIntervalSince1970: 0) }
        set { data[member] = dateFormatter.string(from: newValue) }
    }
    
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.calendar = Calendar(identifier: .gregorian)
        
        return formatter
    }()
}

//func example() {
//    let report =
//    """
//    --== Technical Report ==--
//
//    * Date: ${date}
//    * System Name: ${systemName} ${systemVersion}
//    * Device: ${deviceModel} - ${deviceName}
//    * Processor Count: ${processorCount}
//    """
//
//    var template = Template(template: report)
//
//    template.date = Date()
//    template.systemName = UIDevice.current.systemName
//    template.systemVersion = UIDevice.current.systemVersion
//    template.deviceModel = UIDevice.current.model
//    template.deviceName = UIDevice.current.name
//    template.processorCount = ProcessInfo.processInfo.processorCount
//
//    print(template.populatedTemplate)
//}
