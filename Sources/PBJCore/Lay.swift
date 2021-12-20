//
//  Lay.swift
//  PBJCore
//
//  Created by Ian Clawson on 12/20/21.
//

import Foundation
import UIKit

/// Helpers for allowing namespaced extensions, e.g. `someview.lay.addAutoLayoutSubview`

public protocol LayNamespaceWrappable {
    associatedtype T
    var lay: T { get }
    static var lay: T.Type { get }
}

extension LayNamespaceWrappable {
    public var lay: LayTypeWrapper<Self> {
        return LayTypeWrapper(value: self)
    }

    public static var lay: LayTypeWrapper<Self>.Type {
        return LayTypeWrapper.self
    }
}

public struct LayTypeWrapper<T> {
    var value: T
    init(value: T) {
        self.value = value
    }
}

/// method implementations

extension UIView: LayNamespaceWrappable {}
extension LayTypeWrapper where T: UIView {
    
    /**
     * convenience methods
     */
    
    /// adding
    func addAutoLayoutSubview(_ subview: UIView) {
        value.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addAutoLayoutSubview(subview: UIView, below: UIView) {
        value.insertSubview(subview, belowSubview: below)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addAutoLayoutSubview(subview: UIView, above: UIView) {
        value.insertSubview(subview, aboveSubview: above)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// sizing
    
    @discardableResult
    func size(_ points: Double) -> Self {
        self.height(points)
        self.width(points)
        return self
    }
    
    @discardableResult
    func height(_ height: Double) -> Self {
        NSLayoutConstraint.activate([
            value.heightAnchor.constraint(equalToConstant: CGFloat(height))
            ])
        return self
    }
    
    @discardableResult
    func width(_ width: Double) -> Self {
        NSLayoutConstraint.activate([
            value.widthAnchor.constraint(equalToConstant: CGFloat(width))
            ])
        return self
    }
    
    /// sides
    
    @discardableResult
    func top(_ points: Double) -> Self {
        guard let superview = self.value.superview else { return self }
        NSLayoutConstraint.activate([
            value.topAnchor.constraint(equalTo: superview.lay.safeTopAnchor, constant: CGFloat(points)),
            ])
        return self
    }
    
    @discardableResult
    func bottom(_ points: Double) -> Self {
        guard let superview = self.value.superview else { return self }
        NSLayoutConstraint.activate([
            value.bottomAnchor.constraint(equalTo: superview.lay.safeBottomAnchor, constant: CGFloat(points)),
            ])
        return self
    }
    
    @discardableResult
    func leading(_ points: Double) -> Self {
        guard let superview = self.value.superview else { return self }
        NSLayoutConstraint.activate([
            value.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: CGFloat(points)),
            ])
        return self
    }
    
    @discardableResult
    func trailing(_ points: Double) -> Self {
        guard let superview = self.value.superview else { return self }
        NSLayoutConstraint.activate([
            value.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: CGFloat(points)),
            ])
        return self
    }
    
    /// filling
    
    @discardableResult
    func fillVertically(padding: Double = 0) -> Self {
        self.top(padding)
        self.bottom(-padding)
        return self
    }
    
    @discardableResult
    func fillHorizontally(padding: Double = 0) -> Self {
        self.leading(padding)
        self.trailing(-padding)
        return self
    }
    
    @discardableResult
    func fillContainer(padding: Double = 0) -> Self {
        self.fillVertically(padding: padding)
        self.fillHorizontally(padding: padding)
        return self
    }
    
    /// centering
    
    @discardableResult
    func centerVertically(offset: Double = 0) -> Self {
        guard let superview = self.value.superview else { return self }
        NSLayoutConstraint.activate([
            value.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: CGFloat(offset))
            ])
        return self
    }
    
    @discardableResult
    func centerHorizontally(offset: Double = 0) -> Self {
        guard let superview = self.value.superview else { return self }
        NSLayoutConstraint.activate([
            value.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: CGFloat(offset))
            ])
        return self
    }
    
    @discardableResult
    func centerInContainer() -> Self {
        self.centerVertically()
        self.centerHorizontally()
        return self
    }
    
    /**
     * convenience vars
     */
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        return value.safeAreaLayoutGuide.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        return value.safeAreaLayoutGuide.leftAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        return value.safeAreaLayoutGuide.bottomAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        return value.safeAreaLayoutGuide.rightAnchor
    }
        
    var leftMargin: NSLayoutXAxisAnchor {
        return value.layoutMarginsGuide.leftAnchor
    }
    
    var rightMargin: NSLayoutXAxisAnchor {
        return value.layoutMarginsGuide.rightAnchor
    }
    
    var centerXMargin: NSLayoutXAxisAnchor {
        return value.layoutMarginsGuide.centerXAnchor
    }
    
    var widthMargin: NSLayoutDimension {
        return value.layoutMarginsGuide.widthAnchor
    }
    
    var topMargin: NSLayoutYAxisAnchor {
        return value.layoutMarginsGuide.topAnchor
    }
    
    var bottomMargin: NSLayoutYAxisAnchor {
        return value.layoutMarginsGuide.bottomAnchor
    }
    
    var centerYMargin: NSLayoutYAxisAnchor {
        return value.layoutMarginsGuide.centerYAnchor
    }
    
    var heightMargin: NSLayoutDimension {
        return value.layoutMarginsGuide.heightAnchor
    }
}
