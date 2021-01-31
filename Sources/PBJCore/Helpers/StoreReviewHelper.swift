//
//  StoreReviewHelper.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/26/19.
//  Copyright © 2019 Ian Clawson Apps. All rights reserved.
//

import StoreKit

@available(iOS 10.3, macOS 10.14, *)
public struct StoreReviewHelper {
    public static func checkAndAskForReview(hasAskedThisSession: Bool, numTimesAppOpened: Int, numTimesReviewPrompted: Int) -> Bool {
        
        // only ask once per session
        if hasAskedThisSession {
            return false
        }
        
        // never ask more than 3 times in total ever
        guard numTimesReviewPrompted <= 3 else {
            return false
        }
        
        switch numTimesAppOpened {
        case 10:
            SKStoreReviewController.requestReview()
            return true
        case _ where numTimesAppOpened % 20 == 0 :
            SKStoreReviewController.requestReview()
            return true
        default:
            print("App run count is : \(numTimesAppOpened)")
            return false
        }
    }
}
