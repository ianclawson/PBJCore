//
//  UIAlertController+Ext.swift
//  stars2apples
//
//  Created by Ian Clawson on 4/24/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit

extension UIAlertController {
    convenience init(title: String, error: Error) {
        let message: String
        
        message = error.localizedDescription
        
        self.init(title: title, message: message, preferredStyle: .alert)
        
        self.addAction(.ok)
    }
    
    func setSource(source: UIView?) {
        if let source = source {
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = source.bounds
        }
    }
}

extension UIAlertAction {
    
    class var ok: UIAlertAction {
        return UIAlertAction(title: "OK", style: .default, handler: nil)
    }
    
    class func ok(title: String = "OK", handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: handler)
    }

    class var cancel: UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
    
    class func cancel(title: String = "Cancel", handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .cancel, handler: handler)
    }
    
    class func delete(title: String = "Delete", handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: title, style: .destructive, handler: handler)
    }
    
    class func action(title: String, isDestructive: Bool = false, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: title, style: isDestructive ? .destructive : .default, handler: handler)
    }
}

extension UIActivityViewController {
    func setSource(source: UIView?) {
        if let source = source {
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = source.bounds
        }
    }
}
#endif
