//
//  UserAgent.swift
//  stars2apples
//
//  Created by Ian Clawson on 12/27/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import UIKit

/// Defines a structure for representing a user-agent. You can
public struct UserAgent: Codable, Equatable  {
    
    public static let shared: UserAgent = {
        UserAgent(
            productName: Bundle.main.productName,
            model: UIDevice.current.model,
            appVersion: Bundle.main.version,
            osVersion: Version(UIDevice.current.systemVersion) ?? Version(0, 0, 0),
            networkVersion: Bundle.main.networkVersion,
            kernelVersion: UIDevice.current.kernel
        )
    }()
    
    /// The name of the product. E.g. Notes
    private var productName: String
    /// The model name for this device. E.g. iPhone 8 Plus
    private var model: String
    /// The app versions and build. E.g. 2.1.13-3
    private var appVersion: Version
    /// The OS version. E.g. 14.2
    private var osVersion: Version
    /// The CFNetwork version. E.g. 1206
    private var networkVersion: Version
    /// The Darwin kernel version. E.g. 20.1
    private var kernelVersion: Version
    
}

extension UserAgent: CustomStringConvertible {
    
    public var description: String {
        // Assuming app version: 2.1.13-1
        // "App name/2.1.13-1 (iPhone) iOS/14.2 CFNetwork/1206 Darwin/20.1.0"
        "\(productName)/\(appVersion.formatted(.compact)) (\(model)) os/\(osVersion.formatted(.compact)) CFNetwork/\(networkVersion.formatted(.compact)) Darwin/\(kernelVersion.formatted(.compact))"
    }
    
}

private extension Bundle {
    
    var productName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var build: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
    var version: Version {
        let string = infoDictionary?["CFBundleShortVersionString"] as! String
        return Version(string) ?? Version(0, 0, 0)
    }
    
    var networkVersion: Version {
        let version = Bundle(identifier: "com.apple.CFNetwork")?
            .infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return Version(stringLiteral: version)
    }
    
}

private extension UIDevice {
    
    var kernel: Version {
        var sysinfo = utsname()
        uname(&sysinfo)
        
        if let darwinVersion = String(
            bytes: Data(
                bytes: &sysinfo.release,
                count: Int(_SYS_NAMELEN)
            ),
            
            encoding: .ascii
        )?.trimmingCharacters(in: .controlCharacters) {
            return Version(darwinVersion) ?? Version(0, 0, 0)
        } else {
            return Version(0, 0, 0)
        }
    }
    
    var model: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        
        guard let modelId = String(
            bytes: Data(
                bytes: &sysinfo.machine,
                count: Int(_SYS_NAMELEN)
            ),
            encoding: .ascii
        )?.trimmingCharacters(in: .controlCharacters) else {
            return "Unknown Device"
        }
        
        return name(for: modelId)
    }
    
    func name(for model: String) -> String {
        var name = model
        
        UIDevice.models.enumerateLines { line, stop in
            let components = line.components(separatedBy: " : ")
            guard components[0] == model else { return }
            
            name = components[1]
            stop = true
        }
        
        return name
    }
    
}
