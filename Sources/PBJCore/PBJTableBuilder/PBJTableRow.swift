//
//  PBJTableRow.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/22/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

public struct PBJTableRow<CellType: UITableViewCell>: PBJConfigurableRow where CellType: PBJConfigurableCell {
    public var reuseId: String { return CellType.reuseId }
    public var nib: UINib? { return CellType.nib }
    public var height: CGFloat { return CellType.height }
    public var cellClass: AnyClass { return CellType.self }
    
    public var item: CellType.Value
    public private(set) var actions: [PBJTableAction]
    
    public init(item: CellType.Value, actions: [PBJTableAction] = []) {
        self.item = item
        self.actions = actions
    }
    
    public func configure(cell: UITableViewCell) {
        (cell as? CellType)?.configure(with: item)
    }
}
#endif
