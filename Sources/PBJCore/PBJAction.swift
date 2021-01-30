//
//  Action.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/15/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation
import UIKit
/**
    A wrapper over various UI actions so actions from different comntexts can be used 
 */
struct PBJAction {
    var title: String
    var style: Style
    var image: UIImage? = nil
    var action: ((PBJAction) -> Void)?
    
    init(title: String, style: Style = .default, image: UIImage? = nil, action: ((PBJAction) -> Void)? = nil)
    {
        self.title = title
        self.style = style
        self.image = image
        self.action = action
    }
}

extension PBJAction {
    enum Style {
        case `default`
        case cancel
        case destructive
        case selected
        
        var alertActionStyle: UIAlertAction.Style {
            switch self {
            case .default, .selected: return .default
            case .cancel: return .cancel
            case .destructive: return .destructive
            }
        }
        
        var previewActionStyle: UIPreviewAction.Style? {
            switch self {
            case .default: return .default
            case .destructive: return .destructive
            case .selected: return .selected
            case .cancel: return nil
            }
        }
    }
}

@available(iOS 13, *)
extension PBJAction.Style {
    var menuAttributes: UIMenuElement.Attributes {
        switch self
        {
        case .default, .cancel, .selected: return []
        case .destructive: return  .destructive
        }
    }
    
    var menuState: UIMenuElement.State {
        switch self
        {
        case .default, .cancel, .destructive: return .off
        case .selected: return .on
        }
    }
}

extension UIAlertAction {
    convenience init(_ action: PBJAction)
    {
        self.init(title: action.title, style: action.style.alertActionStyle) { (alertAction) in
            action.action?(action)
        }
    }
}

extension UIPreviewAction {
    convenience init?(_ action: PBJAction) {
        guard let previewActionStyle = action.style.previewActionStyle else { return nil }
        
        self.init(title: action.title, style: previewActionStyle) { (previewAction, viewController) in
            action.action?(action)
        }
    }
}

extension UIAlertController {
    convenience init(actions: [PBJAction]) {
        self.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for action in actions.alertActions
        {
            self.addAction(action)
        }
    }
}

@available(iOS 13.0, *)
extension UIAction {
    convenience init?(_ action: PBJAction) {
        guard action.style != .cancel else { return nil }
        
        self.init(title: action.title, image: action.image, attributes: action.style.menuAttributes, state: action.style.menuState) { _ in
            action.action?(action)
        }
    }
}

extension RangeReplaceableCollection where Iterator.Element == PBJAction {
    var alertActions: [UIAlertAction] {
        let actions = self.map { UIAlertAction($0) }
        return actions
    }
    
    var previewActions: [UIPreviewAction] {
        let actions = self.compactMap { UIPreviewAction($0) }
        return actions
    }
    
    @available(iOS 13.0, *)
    var menuActions: [UIAction] {
        let actions = self.compactMap { UIAction($0) }
        return actions
    }
}

extension PBJAction {
    static var cancel: PBJAction {
        return PBJAction(title: "Cancel", style: .cancel, action: nil)
    }

    static func action(title: String, isDestructive: Bool = false, image: UIImage?, action: ((PBJAction) -> Void)?) -> PBJAction {
        return PBJAction(title: title, style: isDestructive ? .destructive : .default, image: image, action: action)
    }
}
