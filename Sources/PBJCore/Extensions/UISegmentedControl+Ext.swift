//
//  UISegmentedControl+Ext.swift
//  
//
//  Created by Ian Clawson on 1/30/21.
//

#if !os(macOS)
import UIKit

extension UISegmentedControl {
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
#endif
