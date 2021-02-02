//
//  LandscapeNavigationController.swift
//  PBJCore
//
//  Created by Ian Clawson on 5/3/18.
//  Copyright © 2018 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

public class LandscapeNavigationController: UINavigationController {

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return getPreferredOrientation()
    }
    
    private func getPreferredOrientation() -> UIInterfaceOrientation {
        if UIDevice.current.orientation == .landscapeLeft {
            return .landscapeRight
        } else if UIDevice.current.orientation == .landscapeRight {
            return .landscapeLeft
        } else {
            return .landscapeLeft
        }
    }
}
#endif
