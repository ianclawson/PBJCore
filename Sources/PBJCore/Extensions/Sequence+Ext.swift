//
//  Sequence+Ext.swift
//  
//
//  Created by Ian Clawson on 3/1/21.
//

//import Foundation
//
//extension Sequence {
//    func sorted<T: Comparable>(by path: KeyPath<Element, T>) -> [Element] {
//        return self.sorted { (a, b) -> Bool in
//            return a[keyPath: path] < b [keyPath: path]
//        }
//    }
//    func sorted<T: Comparable>(by path: KeyPath<Element, T?>,
//                                default defaultValue: @autoclosure ()->T) -> [Element] {
//        return self.sorted { (a, b) -> Bool in
//            return a[keyPath: path ?? defaultValue()] < b [keyPath: path ?? defaultValue()]
//        }
//    }
//}

// EXAMPLE:

//struct Person {
//    var givenName: String
//    var familyName: String
//}
//
//let people: [Person] = []
//
//let sortedPeople = people.sorted(by: \.familyName)
