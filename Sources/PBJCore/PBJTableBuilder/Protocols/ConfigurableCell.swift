//
//  ConfigurableCell.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/22/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import UIKit

public protocol PBJConfigurableCell {
    associatedtype Value
    
    static var reuseId: String { get }
    static var nib: UINib? { get }
    static var height: CGFloat { get }
    
    func configure(with value: Value)
}

public extension PBJConfigurableCell where Self: UITableViewCell {
    static var reuseId: String {
        return self.reuseIdentifier
    }
    
    static var nib: UINib? {
        return nil
    }
    
    static var height: CGFloat {
//        return 44
        return 200
    }
}

