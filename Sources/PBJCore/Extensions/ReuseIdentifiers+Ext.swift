//
//  ReuseIdentifiers+Ext.swift
//  PBJCore
//
//  Created by Ian Clawson on 1/8/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit

public extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
#endif
