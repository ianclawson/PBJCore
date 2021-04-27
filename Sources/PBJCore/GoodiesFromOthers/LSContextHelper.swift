//  From: Jordan Hipwell via Slack.

//
//  LSContextHelper.swift
//  
//
//  Created by Ian Clawson on 3/29/21.
//

import Foundation
import LocalAuthentication

func gitGudLSContext() {
    let laContext = LAContext()
    if laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
        switch laContext.biometryType {
        case .faceID:
            break //face id asset
        case .touchID:
            break //touch id asset
        case .none:
            break //fall back to device passcode asset
        @unknown default:
            break //something new? 👀
        }
    }
}
