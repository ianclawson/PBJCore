//
//  ToolTipGroup.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/15/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import UIKit

extension UIView {
    func toolTipForGroup(tooltip: ToolTip, offset: CGPoint? = nil) -> GroupToolTip {
        let frame = self.convert(self.bounds, to: UIApplication.shared.windows.first!)
        let offset = offset ?? .zero
        return GroupToolTip(tooltip: tooltip, frame: frame, offset: offset)
    }
}

struct GroupToolTip {
    let tooltip: ToolTip
    let frame: CGRect
    let offset: CGPoint
    
    func position(padding: CGFloat) -> CGPoint {
        let top: CGFloat
        let left: CGFloat
        switch tooltip.location {
        case .top:
           top = frame.minY - tooltip.frame.height - padding
           left = frame.minX + ((frame.width - tooltip.frame.width) / 2.0)
        case .bottom:
           top = frame.minY + frame.height + padding
           left = frame.minX + ((frame.width - tooltip.frame.width) / 2.0)
        case .left:
           top = frame.minY + ((frame.height - tooltip.frame.height) / 2.0)
           left = frame.minX - tooltip.frame.width - padding
        case .right:
           top = frame.minY + ((frame.height - tooltip.frame.height) / 2.0)
           left = frame.minX + frame.width
        case .none:
           top = frame.minY + ((frame.height - tooltip.frame.height) / 2.0)
           left = frame.minX + ((frame.width - tooltip.frame.width) / 2.0)
        }
        
        return CGPoint(x: left + offset.x, y: top + offset.y)
    }
}

class ToolTipQueue: UIViewController {
    
    var tooltipGroups: [[GroupToolTip]] = []
    var presentingWindow: UIWindow?
    var padding: CGFloat = 8.0
    var positionInQueue = 0
    
    class func present(tips: [GroupToolTip]) { // single group
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = ToolTipQueue()
        viewController.tooltipGroups = [tips]
        viewController.presentingWindow = window
        
        window.rootViewController = viewController
        window.windowLevel = UIWindow.Level.alert + 1;
        window.makeKeyAndVisible()
    }
    
    class func present(groups: [[GroupToolTip]]) { // queue of groups
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = ToolTipQueue()
        viewController.tooltipGroups = groups
        viewController.presentingWindow = window
        
        window.rootViewController = viewController
        window.windowLevel = UIWindow.Level.alert + 1;
        window.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        positionInQueue = 0 // ensure we are starting at the beginning
        
        // layout the positioning of all the tooltips
        for tooltips in tooltipGroups {
            for groupToolTip in tooltips {
                let tooltip = groupToolTip.tooltip
               
                tooltip.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(tooltip)

                let position = groupToolTip.position(padding: padding)

                tooltip.isUserInteractionEnabled = false
                tooltip.alpha = 0
                tooltip.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

                NSLayoutConstraint.activate([
                   tooltip.topAnchor.constraint(equalTo: view.topAnchor, constant: position.y),
                   tooltip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: position.x),
                ])
            }
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        show(at: positionInQueue)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func show(at position: Int) {
        
        if position == 0 {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut], animations: {
                self.view.alpha = 1
            })
        }
        
        var delay = 0.0
        
        // present all tooltips with slight delay for awesomeness
        if let tooltips = tooltipGroups[safe: position] {
            
            for groupToolTip in tooltips {
                let tooltip = groupToolTip.tooltip
                
                UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut], animations: {
                    tooltip.alpha = 1
                    tooltip.transform = CGAffineTransform.identity
                })
                
                delay += 0.05
            }
        }
        
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        let currentPosition = positionInQueue
        positionInQueue += 1
        if positionInQueue < tooltipGroups.count {
            // move to next group
            if let currentGroup = tooltipGroups[safe: currentPosition] {
                // hide all current tooltips before presenting next group
                var delay = 0.0
                for groupToolTip in currentGroup {
                    let tooltip = groupToolTip.tooltip
                    
                    UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut], animations: {
                        tooltip.alpha = 0
                        tooltip.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    })
                    
                    delay += 0.05
                }
                
                // present next group
                show(at: positionInQueue)
            }
        } else {
            // all done
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut], animations: {
                self.view.alpha = 0
            }) { (finished) -> Void in
                self.presentingWindow?.resignKey()
                self.presentingWindow = nil
            }
        }
    }
}
