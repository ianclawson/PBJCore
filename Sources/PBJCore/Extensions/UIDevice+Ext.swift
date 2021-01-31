//
//  UIDevice+Ext.swift
//  
//
//  Created by Ian Clawson on 1/30/21.
//

#if !os(macOS)
import UIKit

extension UIDevice {
    class func isCurrentlyLandscape() -> Bool {
        return UIDevice.current.orientation.isValidInterfaceOrientation
            ? UIDevice.current.orientation.isLandscape
            : UIApplication.shared.statusBarOrientation.isLandscape
    }
    class func isCurrentlyPortrait() -> Bool {
        return UIDevice.current.orientation.isValidInterfaceOrientation
            ? UIDevice.current.orientation.isPortrait
            : UIApplication.shared.statusBarOrientation.isPortrait
    }
}

extension UIDeviceOrientation {
    var uiInterfaceOrientation: UIInterfaceOrientation {
        get {
            switch self {
            case .landscapeLeft:        return .landscapeLeft
            case .landscapeRight:       return .landscapeRight
            case .portrait:             return .portrait
            case .portraitUpsideDown:   return .portraitUpsideDown
            case .unknown:              return .unknown
            case .faceUp:               return .unknown
            case .faceDown:             return .unknown
            @unknown default:           return .unknown
            }
        }
    }
    
    init(ui: UIInterfaceOrientation) {
        switch ui {
        case .landscapeRight:       self = .landscapeRight
        case .landscapeLeft:        self = .landscapeLeft
        case .portrait:             self = .portrait
        case .portraitUpsideDown:   self = .portraitUpsideDown
        default:                    self = .portrait
        }
    }
    
    var uiInterfaceOrientationMask: UIInterfaceOrientationMask {
        get {
            switch self {
            case .landscapeLeft:        return .landscapeLeft
            case .landscapeRight:       return .landscapeRight
            case .portrait:             return .portrait
            case .portraitUpsideDown:   return .portraitUpsideDown
            case .unknown:              return .portrait
            case .faceUp:               return .portrait
            case .faceDown:             return .portrait
            @unknown default:           return .portrait
            }
        }
    }
    
    init(ui: UIInterfaceOrientationMask) {
        switch ui {
        case .landscapeRight:       self = .landscapeRight
        case .landscapeLeft:        self = .landscapeLeft
        case .portrait:             self = .portrait
        case .portraitUpsideDown:   self = .portraitUpsideDown
        default:                    self = .portrait
        }
    }
}

extension UIInterfaceOrientation {
    var uiDeviceOrientation: UIDeviceOrientation {
        get {
            switch self {
            case .landscapeLeft:        return .landscapeLeft
            case .landscapeRight:       return .landscapeRight
            case .portrait:             return .portrait
            case .portraitUpsideDown:   return .portraitUpsideDown
            case .unknown:              return .unknown
            @unknown default:           return .unknown
            }
        }
    }
    
    init(ui: UIDeviceOrientation) {
        switch ui {
        case .landscapeRight:       self = .landscapeLeft
        case .landscapeLeft:        self = .landscapeRight
        case .portrait:             self = .portrait
        case .portraitUpsideDown:   self = .portraitUpsideDown
        default:                    self = .portrait
        }
    }
}
#endif
