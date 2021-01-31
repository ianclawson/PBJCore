//
//  UIBarButtonItem+Ext.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/19/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit

extension UIBarButtonItem {
    /// Convenience class method that makes a bar button from a custom button via a image.
    /// This is useful primarily when you need the ui frame of a bar button item. Regular ones don't have a frame,
    /// but by returning the custom view that you used to create the item, you can get the frame from the view.
    /// - Parameters:
    ///   - imageName: the name of the image to be used. `symbolNameWithFallBack` first tries to use an SFSymbol, and falls back to the asset catalog if one of the same name exists.
    ///   - target: the target
    ///   - action: the selector
    class func makeFromCustomView(imageName: String, target: Any, action: Selector, padLeft: Bool = false, padRight: Bool = false) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage.symbolNameWithFallBack(name: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(target, action: action, for: .touchUpInside)
        // add some clickable area to make the buttons easier to click
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: padLeft ? 20.0 : 0, bottom: 5.0, right: padRight ? 20.0 : 0)
        return UIBarButtonItem(customView: button)
    }
    
    class func loadingItem(color: UIColor = .primaryTint) -> UIBarButtonItem {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.color = color
        let loadingBarButton: UIBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        return loadingBarButton
    }
}
#endif
