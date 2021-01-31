//
//  PBJTableSection.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/22/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

public extension PBJTableSection {
    struct SupplementaryView {
        public let view: UIView?
        public let height: CGFloat
        public let title: String?
        
        public init(view: UIView?, height: CGFloat, title: String?) {
            self.view = view
            self.height = height
            self.title = title
        }
        
        public init(view: UIView?, height: CGFloat) {
            self.view = view
            self.height = height
            self.title = nil
        }
        
        public init(title: String?, height: CGFloat) {
            self.view = nil
            self.height = height
            self.title = title
        }
    }
}

public final class PBJTableSection {
    public private(set) var rows: [PBJConfigurableRow]
    
    public private(set) var header: SupplementaryView?
    public private(set) var footer: SupplementaryView?
    
    public subscript(index: Int) -> PBJConfigurableRow {
        return rows[index]
    }
    
    public init(rows: [PBJConfigurableRow]) { self.rows = rows }
    
    public init(rows: PBJConfigurableRow...) { self.rows = rows }
    
    public init(_ rows: [PBJConfigurableRow]...) { self.rows = rows.flatMap { $0 }}
}

public extension PBJTableSection {
    convenience init(header: SupplementaryView? = nil,
                     rows: [PBJConfigurableRow],
                     footer: SupplementaryView? = nil) {
        self.init(rows)
        self.header = header
        self.footer = footer
    }
    
    convenience init(header: SupplementaryView? = nil,
                     rows: PBJConfigurableRow...,
                     footer: SupplementaryView? = nil) {
        self.init(rows)
        self.header = header
        self.footer = footer
    }
}

public extension PBJTableSection {
    func append(_ row: PBJConfigurableRow) {
        self.rows += [row]
    }
    
    func row(at index: Int) -> PBJConfigurableRow? {
        guard index >= 0 && index < rows.count else { return nil }
        return rows[index]
    }
    
    @discardableResult
    func remove(at index: Int) -> PBJConfigurableRow? {
        guard index >= 0 && index < rows.count else { return nil }
        return rows.remove(at: index)
    }
    
    func removeAll() { rows = [] }
    
    func numberOfRows() -> Int { return rows.count }
}
#endif
