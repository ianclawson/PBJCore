//
//  UINavigationController+Ext.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/28/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

public extension UINavigationController {
//    func popToViewController<T: UIViewController>(ofType type: T.Type, animated: Bool) {
//        for controller in self.viewControllers as Array {
//            if controller.isKind(of: type) {
//                self.navigationController?.popToViewController(controller, animated: animated)
//                break
//            }
//        }
//    }
    func popToViewControllerOfType(ofType type: UIViewController.Type, animated: Bool) {
        for controller in self.viewControllers as Array {
            if controller.isKind(of: type) {
                self.popToViewController(controller, animated: animated)
                break
            }
        }
    }
    
    var canNavPop: Bool {
        // in nav, not at first in nav stack; can pop
        // not in nav, or in nav and at first in nav stack; cannot pop
        return visibleViewController != viewControllers.first 
    }
}
#endif
