//
//  URL+Ext.swift
//  
//
//  Created by Ian Clawson on 1/30/21.
//

import Foundation

public extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
}
