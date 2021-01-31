//
//  Optional+Ext.swift
//  
//
//  Created by Ian Clawson on 1/30/21.
//

import Foundation

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public extension Optional {
    var isNil: Bool {
        return self == nil
    }
    var isNotNil: Bool {
        return self == nil
    }
}
