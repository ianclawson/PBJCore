//
//  Actions.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/22/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

public enum PBJTableAction {
    public typealias SelectAction = (IndexPath) -> Void
    public typealias EditAction = (action: UITableViewRowAction, backgroundColor: UIColor)
    
    case select(SelectAction)
    case deselect(SelectAction)
    case edit([EditAction])
}
#endif
