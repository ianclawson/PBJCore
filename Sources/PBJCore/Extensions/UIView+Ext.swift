//
//  UIView+Ext.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/15/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

public extension UIView {
    
//    public convenience init(superView: UIView, padding: CGFloat) {
//        self.init(frame: CGRect(x: superView.x() + padding, y: superView.y() + padding, width: superView.width() - padding*2, height: superView.height() - padding*2))
//    }
    
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func addSubview(_ view: UIView, pinningEdgesWith insets: UIEdgeInsets) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)

        if let pinningConstraints = NSLayoutConstraint.constraintsPinningEdgesOf(view, toEdgesOf: self, with: insets) {
            NSLayoutConstraint.activate(pinningConstraints)
        }
    }

    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    class func makeEmptyStateView(bounds: CGRect, message: String, image: UIImage? = nil, detailMessage: String? = nil) -> UIView {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        outerView.backgroundColor = .clear
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .clear
        
        let label = UILabel()
        view.addSubview(label)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -25).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.sizeToFit()
        
        if let img = image {
            let imageView = UIImageView(image: img)
            view.addSubview(imageView)
            imageView.tintColor = .gray
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -16).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        
        if let dm = detailMessage {
            let detail = UILabel()
            view.addSubview(detail)
            detail.textColor = .gray
            detail.translatesAutoresizingMaskIntoConstraints = false
            detail.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
            detail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            detail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
            detail.text = dm
            detail.numberOfLines = 0
            detail.textAlignment = .center
            detail.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            detail.sizeToFit()
        }
        
        outerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: outerView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(
            equalTo: outerView.safeAreaLayoutGuide.centerYAnchor,
            constant: UIDevice.isCurrentlyLandscape()
                ? 70
                : 0
        ).isActive = true
        
        return outerView
    }
}

#if DEBUG
public extension UIView {
    func debugBorder(color: UIColor = .red, debugBackground: Bool = false) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        
        if debugBackground {
            backgroundColor = color.withAlphaComponent(0.5)
        }
    }
}
#endif

// for future thumbnail editor usage
//
// https://stackoverflow.com/questions/39283807/how-to-take-screenshot-of-portion-of-uiview

public extension UIView {

    /// Create image snapshot of view.
    ///
    /// - Parameters:
    ///   - rect: The coordinates (in the view's own coordinate space) to be captured. If omitted, the entire `bounds` will be captured.
    ///   - afterScreenUpdates: A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated. Specify the value false if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes. Defaults to `true`.
    ///
    /// - Returns: The `UIImage` snapshot.

    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}

//public extension UIView {
//
//    /// Create snapshot
//    ///
//    /// - Parameters:
//    ///   - rect: The coordinates (in the view's own coordinate space) to be captured. If omitted, the entire `bounds` will be captured.
//    ///   - afterScreenUpdates: A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated. Specify the value false if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes. Defaults to `true`.
//    ///
//    /// - Returns: Returns `UIImage` of the specified portion of the view.
//
//    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage? {
//        // snapshot entire view
//
//        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
//        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
//        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        // if no `rect` provided, return image of whole view
//
//        guard let image = wholeImage, let rect = rect else { return wholeImage }
//
//        // otherwise, grab specified `rect` of image
//
//        guard let cgImage = image.cgImage?.cropping(to: rect * image.scale) else { return nil }
//        return UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
//    }
//
//}

public extension NSLayoutConstraint {
    class func constraintsPinningEdgesOf(_ view1: UIView, toEdgesOf view2: UIView) -> [NSLayoutConstraint]? {
        return self.constraintsPinningEdgesOf(view1, toEdgesOf: view2, with: .zero)
    }

    class func constraintsPinningEdgesOf(_ view1: UIView, toEdgesOf view2: UIView, with insets: UIEdgeInsets) -> [NSLayoutConstraint]? {
        let topConstraint = view1.topAnchor.constraint(equalTo: view2.topAnchor, constant: insets.top)
        let bottomConstraint = view2.bottomAnchor.constraint(equalTo: view1.bottomAnchor, constant: insets.bottom)
        let leftConstraint = view1.leftAnchor.constraint(equalTo: view2.leftAnchor, constant: insets.left)
        let rightConstraint = view2.rightAnchor.constraint(equalTo: view1.rightAnchor, constant: insets.right)

        return [topConstraint, bottomConstraint, leftConstraint, rightConstraint].compactMap { $0 }
    }
}
#endif
