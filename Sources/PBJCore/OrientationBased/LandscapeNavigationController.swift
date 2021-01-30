//
//  LandscapeNavigationController.swift
//  stars2apples
//
//  Created by Ian Clawson on 5/3/18.
//  Copyright © 2018 Ian Clawson Apps. All rights reserved.
//

import UIKit

class LandscapeNavigationController: UINavigationController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return getPreferredOrientation()
    }
    
    func getPreferredOrientation() -> UIInterfaceOrientation {
        if UIDevice.current.orientation == .landscapeLeft {
            return .landscapeRight
        } else if UIDevice.current.orientation == .landscapeRight {
            return .landscapeLeft
        } else {
            return .landscapeLeft
        }
    }
}
