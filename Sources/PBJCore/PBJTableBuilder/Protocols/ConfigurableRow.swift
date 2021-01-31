//
//  ConfigurableRow.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/22/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

public protocol PBJConfigurableRow {
    var reuseId: String { get }
    var nib: UINib? { get }
    var height: CGFloat { get }
    var cellClass: AnyClass { get }
    var actions: [PBJTableAction] { get }
    
    func configure(cell: UITableViewCell)
}
#endif
