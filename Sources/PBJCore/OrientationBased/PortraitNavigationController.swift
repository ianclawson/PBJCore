//
//  PortraitNavigationController.swift
//  stars2apples
//
//  Created by Ian Clawson on 5/24/19.
//  Copyright © 2019 Ian Clawson Apps. All rights reserved.
//

import UIKit

class PortraitNavigationController: UINavigationController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

}
