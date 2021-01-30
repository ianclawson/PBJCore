//
//  ToolTipTracker.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/15/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import Foundation

class ToolTipTracker {
    static let shared = ToolTipTracker()
    
    private var tooltips = [String: WeakRef<ToolTip>]()
    
    func tooltip(for message: String) -> ToolTip? {
        return tooltips[message]?.value
    }
    
    func append(tooltip: ToolTip) {
        tooltips[tooltip.message] = WeakRef(value: tooltip)
    }
    
    func dismiss(message: String) {
        tooltips[message]?.value?.dismiss()
        tooltips.removeValue(forKey: message)
    }
    
    func dismissAll() {
        for (_, tooltip) in tooltips {
            tooltip.value?.dismiss()
        }
        
        tooltips.removeAll()
    }
}
#endif
