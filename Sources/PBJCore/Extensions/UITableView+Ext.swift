//
//  TableView+Ext.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/6/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

// MARK: - Extensions

public extension UITableView {
    /// This method takes a lot of the brute force out of configuring table views, but also makes some assumptions that are important to note:
    /// 1.) the cell class passed in has an associate xib (becuase of the `self.register` below), and
    /// 2.) the `cellTypes` that are passed in assume that, in their Xibs, *their reuse identifier is the same as their classname.*
    /// As in, if one of the passed in cell classes is `SwitchTableViewCell`, then that class's reuse identifier in the associated
    /// Xib file _must also be_ `SwitchTableViewCell`.
    /// - Parameters:
    ///   - delegate: delegate
    ///   - dataSource: dataSource
    ///   - prefetchDataSource: prefetchDataSource
    ///   - cellClassTypes: cellClassTypes
    ///   - cellNibTypes: cellNibTypes
    func configure(
        delegate: UITableViewDelegate? = nil,
        dataSource: UITableViewDataSource? = nil,
        prefetchDataSource: UITableViewDataSourcePrefetching? = nil,
        dragDelegate: UITableViewDragDelegate? = nil,
        dropDelegate: UITableViewDropDelegate? = nil,
        cellClassTypes: [UITableViewCell.Type] = [],
        cellNibTypes: [UITableViewCell.Type] = []
    ) {
        if let delegate = delegate {
            self.delegate = delegate
        }
        if let dataSource = dataSource {
            self.dataSource = dataSource
        }
        if let prefetchDataSource = prefetchDataSource {
            self.prefetchDataSource = prefetchDataSource
        }
        if let dragDelegate = dragDelegate, let dropDelegate = dropDelegate {
            self.dragDelegate = dragDelegate
            self.dropDelegate = dropDelegate
            self.dragInteractionEnabled = true
        }
        for cellType in cellClassTypes {
            self.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
        for cellType in cellNibTypes {
            self.register(
                UINib(nibName: cellType.reuseIdentifier, bundle: nil),
                forCellReuseIdentifier: cellType.reuseIdentifier
            )
        }
    }
    
    final func dq<T: UITableViewCell>(_ cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand"
            )
        }
        return cell
    }
}

// MARK: - Empty State Helpers

public extension UITableView {
    func setEmptyState(message: String, image: UIImage? = nil, detailMessage: String? = nil) {
        self.backgroundView = UIView.makeEmptyStateView(bounds: self.bounds, message: message, image: image, detailMessage: detailMessage)
    }
    
    func setLoadingState(color: UIColor) {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.color = color
        activityIndicator.startAnimating()
        self.backgroundView = activityIndicator
    }
    
    func removeEmptyState() {
        self.backgroundView = nil
    }
}

// MARK: - Cell Builder Methods

public extension UITableView {
    
    func emptyCell() -> UITableViewCell {
        var cell = dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: UITableViewCell.reuseIdentifier)
        }
        return cell!
    }
    
    enum DefaultCellType {
        case normal
        case appIcon
    }
    
    func defaultCell(titleText: String, image: UIImage? = nil, accessory: UITableViewCell.AccessoryType = .none, reuseIdentifier: String = "defaultCell", type: DefaultCellType = .normal) -> UITableViewCell {
        var cell = dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        }
        cell?.textLabel?.text = titleText
        switch type {
        case .normal:
            cell?.imageView?.image = image
        case .appIcon:
            cell?.imageView?.layer.masksToBounds = true
            cell?.imageView?.layer.cornerRadius = 13
            if #available(iOS 13.0, *)
            {
                cell?.imageView?.layer.cornerCurve = CALayerCornerCurve.continuous
            }
            cell?.imageView?.image = image
        }
        
        cell?.accessoryType = accessory
        return cell!
    }
    
    func detailCell(titleText: String, detailText: String = "", accessory: UITableViewCell.AccessoryType = .none, reuseIdentifier: String = "detailCell") -> UITableViewCell {
        var cell = dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
        }
        cell?.textLabel?.text = titleText
        cell?.detailTextLabel?.text = detailText
        
        if detailText == "(required)" {
            cell?.detailTextLabel?.textColor = .red
        } else {
            cell?.detailTextLabel?.textColor = .gray
        }
        
//        if let fileSize = fileSize {
//            cell?.detailTextLabel?.text = DiskHelper.sizeDescText(for: NSNumber(value: fileSize))
//            cell?.detailTextLabel?.textColor = DiskHelper.sizeDescColor(for: NSNumber(value: fileSize))
//        }

        cell?.accessoryType = accessory
        return cell!
    }
    
    func subtitleCell(titleText: String, detailText: String = "", reuseIdentifier: String = "subtitleCell") -> UITableViewCell {
        var cell = dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }
        cell?.textLabel?.text = titleText
        cell?.detailTextLabel?.text = detailText
        return cell!
    }
}

// MARK: - Convenience

public extension UITableView {
    func performDeselectRowsAt(_ indexPath: IndexPath) {
        beginUpdates()
        deselectRow(at: indexPath, animated: true)
        endUpdates()
    }
}
#endif
