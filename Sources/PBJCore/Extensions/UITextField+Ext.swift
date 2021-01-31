//
//  UITextField+Ext.swift
//  stars2apples
//
//  Created by Ian Clawson on 6/1/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UITextField {
    
    func left(image: UIImage?, color: UIColor = .black) {
        if let image = image {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
    
    func right(image: UIImage?, color: UIColor = .black) {
        if let image = image {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
#endif
