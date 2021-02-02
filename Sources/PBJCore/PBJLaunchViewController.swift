//
//  PBJLaunchViewController.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/5/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

public class PBJLaunchCondition: NSObject {
    private(set) var condition: (() -> Bool)
    private(set) var action: ((_ completionHandler: @escaping ((_ error: Error?) -> Void)) -> Void)

    public init(condition: @escaping (() -> Bool), action: @escaping (_ completionHandler: @escaping ((_ error: Error?) -> Void)) -> Void) {
        self.condition = condition
        self.action = action
        super.init()
    }
}

open class PBJLaunchViewController: UIViewController {
    
    open private(set) var launchConditions = [PBJLaunchCondition]()
    
    private var launchView: UIView?
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        guard let storyboardName = Bundle.main.object(forInfoDictionaryKey: "UILaunchStoryboardName") as? String else {
            return
        }

        if Bundle.main.url(forResource: storyboardName, withExtension: "nib") != nil {
            let launchNib = UINib(nibName: storyboardName, bundle: Bundle.main)

            let objects = launchNib.instantiate(withOwner: nil, options: nil)

            for view in objects {
                guard let view = view as? UIView else {
                    continue
                }
                
                launchView = view
                break
            }
        } else {
            let launchStoryboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)

            let initialViewController = launchStoryboard.instantiateInitialViewController()
            launchView = initialViewController?.view
        }
        
        guard let launchView = launchView else {
            return
        }
        
        view.addSubview(launchView, pinningEdgesWith: UIEdgeInsets.zero)
        view.sendSubviewToBack(launchView)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        handleLaunchConditions()
    }

    
    public func handleLaunchConditions() {
        handleLaunchCondition(at: 0)
    }
    
    func handleLaunchCondition(at index: Int) {
        if !Thread.isMainThread {
            DispatchQueue.main.async(execute: {
                self.handleLaunchCondition(at: index)
            })

            return
        }
        
        if index >= launchConditions.count {
            finishLaunching()

            return
        }

        let condition = launchConditions[index]

        if condition.condition() {
            handleLaunchCondition(at: index + 1)
        } else {
            
            condition.action({ error in
                
                if let error = error {
                    self.rst_dispatch_sync_on_main_thread({
                        self.handleLaunchError(error)
                    })

                    return
                }

                self.handleLaunchCondition(at: index + 1)
            })
        }
    }

    open func handleLaunchError(_ error: Error) {
        print("Launch Error: %@", error.localizedDescription)
    }
    
    open func finishLaunching() { }

    func rst_dispatch_sync_on_main_thread(_ block:  @escaping () -> ()) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync(execute: block)
        }
    }

}
#endif
