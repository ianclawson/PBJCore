//
//  UIButton+Ext.swift
//  
//
//  Created by Ian Clawson on 1/30/21.
//

#if !os(macOS)
import UIKit

extension UIButton {
    func setTitle(_ title: String?, for state: UIControl.State, animated: Bool) {
        if animated {
            self.setTitle(title, for: state)
        } else {
            UIView.performWithoutAnimation {
                self.setTitle(title, for: state)
                self.layoutIfNeeded()
            }
        }
    }
}
#endif
