//
//  ReuseIdentifiers+Ext.swift
//  stars2apples
//
//  Created by Ian Clawson on 1/8/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
