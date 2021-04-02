//
//  LSContextHelper.swift
//  
//
//  Created by Ian Clawson on 3/29/21.
//  From: Jordan Hipwell via Slack.
//

import Foundation

func gitGudLSContext() {
    let laContext = LAContext()
    if laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
        switch laContext.biometryType {
        case .faceID:
            //face id asset
        case .touchID:
            //touch id asset
        case .none:
            //fall back to device passcode asset
        @unknown default:
            //something new? 👀
        }
    }
}
