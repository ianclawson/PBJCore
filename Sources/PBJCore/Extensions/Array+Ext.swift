//
//  Array+Ext.swift
//  PBJCore
//
//  Created by Ian Clawson on 1/8/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation

public extension Array {
    func take(_ elementsCount: Int) -> [Element] {
        let min = Swift.min(elementsCount, count)
        return Array(self[0..<min])
    }
    
    func takeLast(_ elementsCount: Int) -> [Element] {
        let min = Swift.min(elementsCount, count)
        return Array(self.reversed()[0..<min]).reversed()
    }
}

// from SwiftyDraw
public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array where Element: Hashable {
     func difference(from other: [Element]) -> [Element] {
         let thisSet = Set(self)
         let otherSet = Set(other)
         return Array(thisSet.symmetricDifference(otherSet))
     }
 }

public extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

// from AlertsAndPickers
public extension Array {
    
    @discardableResult
    mutating func append(_ newArray: Array) -> CountableRange<Int> {
        let range = count..<(count + newArray.count)
        self += newArray
        return range
    }
    
    @discardableResult
    mutating func insert(_ newArray: Array, at index: Int) -> CountableRange<Int> {
        let mIndex = Swift.max(0, index)
        let start = Swift.min(count, mIndex)
        let end = start + newArray.count
        
        let left = self[0..<start]
        let right = self[start..<count]
        self = left + newArray + right
        return start..<end
    }
    
    mutating func remove<T: AnyObject> (_ element: T) {
        let anotherSelf = self
        
        removeAll(keepingCapacity: true)
        
        anotherSelf.each { (index: Int, current: Element) in
            if (current as! T) !== element {
                self.append(current)
            }
        }
    }
    
    func each(_ exe: (Int, Element) -> ()) {
        for (index, item) in enumerated() {
            exe(index, item)
        }
    }
}

public extension Array where Element: Equatable {
    
    /// Remove Dublicates
    var unique: [Element] {
        // Thanks to https://github.com/sairamkotha for improving the method
        return self.reduce([]){ $0.contains($1) ? $0 : $0 + [$1] }
    }

    /// Check if array contains an array of elements.
    ///
    /// - Parameter elements: array of elements to check.
    /// - Returns: true if array contains all given items.
    func contains(_ elements: [Element]) -> Bool {
        guard !elements.isEmpty else { // elements array is empty
            return false
        }
        var found = true
        for element in elements {
            if !contains(element) {
                found = false
            }
        }
        return found
    }
    
    /// All indexes of specified item.
    ///
    /// - Parameter item: item to check.
    /// - Returns: an array with all indexes of the given item.
    func indexes(of item: Element) -> [Int] {
        var indexes: [Int] = []
        for index in 0..<self.count {
            if self[index] == item {
                indexes.append(index)
            }
        }
        return indexes
    }
    
    /// Remove all instances of an item from array.
    ///
    /// - Parameter item: item to remove.
    mutating func removeAll(_ item: Element) {
        self = self.filter { $0 != item }
    }
    
    /// Creates an array of elements split into groups the length of size.
    /// If array can’t be split evenly, the final chunk will be the remaining elements.
    ///
    /// - parameter array: to chunk
    /// - parameter size: size of each chunk
    /// - returns: array elements chunked
    func chunk(size: Int = 1) -> [[Element]] {
        var result = [[Element]]()
        var chunk = -1
        for (index, elem) in self.enumerated() {
            if index % size == 0 {
                result.append([Element]())
                chunk += 1
            }
            result[chunk].append(elem)
        }
        return result
    }
}

public extension Array {
    
    /// Random item from array.
    var randomItem: Element? {
        if self.isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    
    /// Shuffled version of array.
    var shuffled: [Element] {
        var arr = self
        for _ in 0..<10 {
            arr.sort { (_,_) in arc4random() < arc4random() }
        }
        return arr
    }

    /// Element at the given index if it exists.
    ///
    /// - Parameter index: index of element.
    /// - Returns: optional element (if exists).
    func item(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
}

public extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
