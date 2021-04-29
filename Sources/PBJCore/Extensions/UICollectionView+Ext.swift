//
//  CollectionView+Ext.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/15/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

public extension UICollectionView {
    func configure(
        delegate: UICollectionViewDelegate? = nil,
        dataSource: UICollectionViewDataSource? = nil,
        prefetchDataSource: UICollectionViewDataSourcePrefetching? = nil,
        dragDelegate: UICollectionViewDragDelegate? = nil,
        dropDelegate: UICollectionViewDropDelegate? = nil,
        cellClassTypes: [UICollectionViewCell.Type] = [],
        cellNibTypes: [UICollectionViewCell.Type] = [],
        headerNibTypes: [UICollectionReusableView.Type] = []
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
            self.reorderingCadence = .fast
        }
        for cellType in cellClassTypes {
            self.register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
        }
        for cellType in cellNibTypes {
            self.register(
                UINib(nibName: cellType.reuseIdentifier, bundle: nil),
                forCellWithReuseIdentifier: cellType.reuseIdentifier
            )
        }
        for headerType in headerNibTypes {
            self.register(
                UINib(nibName: headerType.reuseIdentifier, bundle: nil),
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: headerType.reuseIdentifier
            )
        }
    }
    
    final func dq<T: UICollectionViewCell>(indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
              "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand"
            )
        }
        return cell
    }
    
    final func dq<T: UICollectionReusableView>(kind: String, indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
              "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand"
            )
        }
        return cell
    }
}


// MARK: - Empty State Helpers

public extension UICollectionView {
    func setEmptyState(message: String, image: UIImage? = nil, detailMessage: String? = nil) {
        self.backgroundView = UIView.makeEmptyStateView(bounds: self.bounds, message: message, image: image, detailMessage: detailMessage)
    }
    func removeEmptyState() {
        self.backgroundView = nil
    }
}

// MARK: - Cell Extensions

#endif
