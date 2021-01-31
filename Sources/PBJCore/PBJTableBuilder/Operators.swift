//
//  Operators.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/22/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
public func += (section: PBJTableSection, _ row: PBJConfigurableRow) {
    section.append(row)
}

public func += (builder: PBJTableBuilder, section: PBJTableSection) {
    builder.append(section: section)
}

public func += (builder: PBJTableBuilder, rows: [PBJConfigurableRow]) {
    builder.append(section: PBJTableSection(rows))
}

public func + (lhs: PBJTableSection, rhs: PBJTableSection) -> [PBJTableSection] {
    return [lhs, rhs]
}

public func + (lhs: PBJConfigurableRow, rhs: PBJConfigurableRow) -> [PBJConfigurableRow] {
    return [lhs, rhs]
}
#endif
