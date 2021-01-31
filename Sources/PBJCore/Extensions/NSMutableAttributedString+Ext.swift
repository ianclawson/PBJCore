//
//  NSMutableAttributedString+Ext.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/26/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

extension NSMutableAttributedString {
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    func setBoldText(textForAttribute: String, fontSize: CGFloat) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range)
    }
}
#endif
